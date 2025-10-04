# Service para migração de clientes
module Migration
  class AsaasMigrationService
    def initialize
      @asaas_gateway = PaymentGatewayFactory.create(:asaas)
      @pagarme_gateway = PaymentGatewayFactory.create(:pagarme)
    end

    def migrate_customer_batch(batch_size: 100)
      customers_to_migrate = Customer.joins(:billing_profiles)
                    .where(billing_profiles: { gateway_type: "asaas" })
                    .limit(batch_size)

      if customers_to_migrate.empty?
      Rails.logger.info "[AsaasMigrationService] Sem registro para migrar "
      return
      end

      customers_to_migrate.find_each do |customer|
      migrate_customer(customer)
      end
    end

    def migrate_customer(customer)
      ActiveRecord::Base.transaction do
        # 1. Cria cliente no Pagar.me
        pagarme_customer = @pagarme_gateway.create_customer({
          name: customer.name,
          email: customer.email,
          document: customer.document
        })

        customer.billing_profiles.where(gateway_type: "asaas").each do |profile|
          # 2. Migra assinaturas ativas
          migrate_active_subscriptions(profile, pagarme_customer["id"])

          # 3. Atualiza perfil
          profile.update!(
            gateway_customer_id: pagarme_customer["id"],
            gateway_type: @pagarme_gateway.gateway_name,
            migrated_at: Time.current
          )
        end

        # 4. Mantém histórico ASAAS para auditoria
        create_migration_log(customer, pagarme_customer["id"])
      end
    rescue => e
      Rails.logger.error "Migration failed for customer #{customer.id}: #{e.message}"
      raise
    end

    private

    def migrate_active_subscriptions(billing_profile, pagarme_customer_id)
      billing_profile.subscriptions.active.each do |subscription|
        # Cancela no ASAAS
        @asaas_gateway.cancel_subscription(subscription.gateway_subscription_id)

        # Cria no Pagar.me
        pagarme_subscription = @pagarme_gateway.create_subscription({
          customer_id: pagarme_customer_id,
          plan_id: subscription.plan_id,
          payment_method: "credit_card" # ou outro método padrão
        })

        # Atualiza referência local
        subscription.update!(
          gateway_subscription_id: pagarme_subscription["id"],
          gateway_type: "pagarme"
        )
      end
    end

    def create_migration_log(customer, new_gateway_customer_id)
      MigrationLog.create!(
        customer: customer,
        old_gateway: "asaas",
        new_gateway: "pagarme",
        new_gateway_customer_id: new_gateway_customer_id,
        migration_date: Time.current,
        status: :completed
      )
    end
  end
end
