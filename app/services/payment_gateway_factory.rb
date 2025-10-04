
# app/services/payment_gateway_factory.rb
# Factory para gateways
class PaymentGatewayFactory
  def self.create(gateway_type = :pagarme)
    case gateway_type
    when :pagarme
      Pagarme::PagarmeGateway.new
    when :asaas
      Asaas::AsaasGateway.new  # Para migração
    else
      raise ArgumentError, "Unknown gateway type: #{gateway_type}"
    end
  end
end
