class SubscriptionUpdateJob < ApplicationJob
  queue_as :default

  # Agora recebe o ID da subscription e o status desejado
  def perform(subscription_id, target_status)
    subscription = Subscription.find(subscription_id)

    ActiveSupport::Notifications.instrument(
      "subscription.processed",
      subscription_id: subscription.id,
      gateway_subscription_id: subscription.gateway_subscription_id
    ) do
      sleep 2 # simula operação demorada

      subscription.update!(status: target_status)

      Rails.logger.info "✅ subscription #{subscription.id} atualizado para #{target_status} com Sidekiq"
    end
  end
end
