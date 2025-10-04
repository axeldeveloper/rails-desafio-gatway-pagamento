# Interface para qualquer gateway
class PaymentGateway
  def create_customer(customer_data)
    raise NotImplementedError
  end

  def create_subscription(subscription_data)
    raise NotImplementedError
  end

  def create_payment(payment_data)
    raise NotImplementedError
  end

  def cancel_subscription(subscription_id)
    raise NotImplementedError
  end

  def handle_webhook(payload)
    raise NotImplementedError
  end
end
