# frozen_string_literal: true

# app/errors/common/erros.rb
module Common
  # Erro genérico para quando não conseguimos carregar um site externo
  class ErrorLoadingSite < StandardError; end


  # Erros relacionados a integração com gateways e billing
  class SubscriptionCreationError < StandardError; end
  class PaymentGatewayError      < StandardError; end
  class BillingProfileError      < StandardError; end
  class SubscriptionCancellationError < StandardError; end

  # Erros relacionados a entidades de negócio
  class CustomerNotFoundError    < StandardError; end
  class ProductNotFoundError     < StandardError; end
  class PlanNotFoundError        < StandardError; end
end
