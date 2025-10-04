# Service para criação de assinaturas
class SubscriptionService
  def initialize(gateway: PaymentGatewayFactory.create)
    @gateway = gateway
  end

  def create_subscription(customer_id:, product_code:, plan_id:, payment_method:)
    ActiveRecord::Base.transaction do
      customer = Customer.find(customer_id)
      product = Product.find_by!(code: product_code)
      plan = Plan.find(plan_id)
      pm = PaymentMethod.for_customer_and_kind(customer_id, payment_method).first

      # Cria ou recupera perfil de cobrança
      billing_profile = find_or_create_billing_profile(customer, product)


      # Cria assinatura no gateway
      gateway_response = @gateway.create_subscription({
        customer_id: billing_profile.gateway_customer_id,
        plan_id: plan.id,
        payment_method: payment_method
      })


      # Cria assinatura local
      subscription = Subscription.create!(
        billing_profile: billing_profile,
        plan: plan,
        payment_method_id: pm.id,
        gateway_subscription_id: gateway_response["id"],
        pagarme_subscription_id: gateway_response["id"], # via store_accessor
        status: :pending,
        started_at: Time.current
      )

      # Dispara evento de criação
      ActiveSupport::Notifications.instrument(
        "subscription.create", subscription_id: subscription.id,
        gateway_subscription_id: subscription.gateway_subscription_id
      )

      # Agenda processamento assíncrono no Sidekiq
      # Ativar assinatura
      SubscriptionUpdateJob.perform_later(subscription.id, :active)

      subscription
    end
  rescue => e
    Rails.logger.error "Error creating subscription: #{e.message}"
    raise Common::SubscriptionCreationError, e.message
  end

  def cancel_subscription(subscription_id, cancel_pending_invoices: true)
    subscription = Subscription.find(subscription_id)
    gateway_subscription_id = subscription.gateway_subscription_id || subscription.pagarme_subscription_id  # fallback


    # Cria assinatura no gateway
    gateway_response = @gateway.cancel_subscription(
      gateway_subscription_id,
      cancel_pending_invoices: cancel_pending_invoices) if gateway_subscription_id.present?


    puts "Cancelamento no gateway:"
    puts gateway_response.inspect

    # Cancelar assinatura
    SubscriptionUpdateJob.perform_later(subscription.id, :canceled)

    # subscription.update!(status: :canceled, ended_at: Time.current)
    subscription
  rescue => e
    Rails.logger.error "Error canceling subscription: #{e.message}"
    raise Common::SubscriptionCancellationError, e.message
  end

  private

  def find_or_create_billing_profile(customer, product)
    BillingProfile.find_or_create_by(customer: customer, product: product) do |profile|
      # Cria cliente no gateway se necessário
      gateway_customer = @gateway.create_customer({
        name: customer.name,
        email: customer.email,
        document: customer.document
      })
      profile.gateway_customer_id = gateway_customer["id"]
      profile.gateway_type = @gateway.gateway_name
    end
  end
end
