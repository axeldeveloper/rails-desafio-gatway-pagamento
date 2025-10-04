class CustomerGatewaySyncJob
  include Sidekiq::Job

  def perform(customer_id)
    customer = Customer.find(customer_id)
    Rails.logger.info "[CustomerGatewaySyncJob] POST customer #{customer}"

    # Cria/atualiza no Pagarme
    pagarme_id = PaymentGatewayFactory.create(:pagarme).create_customer(customer)
    Rails.logger.info "[CustomerGatewaySyncJob] Retorno do pagarme #{pagarme_id["id"]  } atualizado com Sidekiq"
    customer.set_external_id(:pagarme_id, pagarme_id["id"])

    # Cria/atualiza no Asaas
    asaas_id = PaymentGatewayFactory.create(:asaas).create_customer(customer)
    Rails.logger.info "[CustomerGatewaySyncJob] Retorno do asaas #{asaas_id["id"]  } atualizado com Sidekiq"
    customer.set_external_id(:asaas_id, asaas_id["id"])

    customer.save!

    sync_billing_profiles(customer, asaas_id:, pagarme_id:)
  end


  def sync_billing_profiles(customer, asaas_id:, pagarme_id:)
    upsert_billing_profile(customer, "asaas", asaas_id["id"])
    sleep 3 # simula operação demorada
    upsert_billing_profile(customer, "pagarme", pagarme_id["id"])
  end

  private

  def upsert_billing_profile(customer, gateway_type, external_id)
    billing_profile = customer.billing_profiles.find_or_initialize_by(gateway_type: gateway_type)
    billing_profile.gateway_customer_id = external_id

    # --- Handle required belongs_to :product if present ---
    product_assoc = billing_profile.class.reflect_on_association(:product)
    if product_assoc
      # association_optional = product_assoc.options[:optional] == true
      if  billing_profile.product.nil?
        product = Product.first
        unless product
          Rails.logger.error "⚠️ [CustomerGatewaySyncJob] Nenhum Product disponível para associar ao BillingProfile #{gateway_type} (customer_id=#{customer.id}). Não será salvo."
          return false
        end

        billing_profile.product = product
        billing_profile.customer = customer
      end
    end

    if billing_profile.save
      Rails.logger.info "[CustomerGatewaySyncJob] BillingProfile #{gateway_type} atualizado com sucesso (ID: #{external_id})"
    else
      Rails.logger.error "[CustomerGatewaySyncJob] Erro ao salvar BillingProfile #{gateway_type}: #{billing_profile.errors.full_messages.join(', ')}"
    end
  end
end
