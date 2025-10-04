class MigrationRollbackService
  def rollback_customer(customer_id)
    customer = Customer.find(customer_id)
    migration_log = MigrationLog.find_by(customer: customer)

    return unless migration_log

    ActiveRecord::Base.transaction do
      # Cancela assinaturas no Pagar.me
      customer.subscriptions.where(gateway_type: "pagarme").each do |subscription|
        @pagarme_gateway.cancel_subscription(subscription.gateway_subscription_id)
      end

      # Restaura dados ASAAS do log
      restore_asaas_data(customer, migration_log)

      migration_log.update!(rolled_back_at: Time.current)
    end
  end
end
