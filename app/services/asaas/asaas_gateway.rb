module Asaas
  class AsaasGateway < PaymentGateway
    include HTTParty

    # base_uri "https://api.asaas.com/v3"
    base_uri "http://localhost:3001/"

    def initialize
      @headers = {
        "access_token" => Rails.application.credentials.asaas.api_key,
        "Content-Type" => "application/json"
      }
      @gateway_name = :asaas
    end

    #
    # Criação de cliente
    # Docs: https://docs.asaas.com/reference/create-new-customer
    #
    # Exemplo de customer_data:
    # {
    #   name: "John Doe",
    #   cpfCnpj: "19540550000121",
    #   email: "john@example.com",
    #   phone: "4733333333",
    #   mobilePhone: "4799376637",
    #   postalCode: "88000000",
    #   address: "Rua X",
    #   addressNumber: "123",
    #   complement: "Apto 1",
    #   province: "SC"
    # }
    def create_customer(customer_data)
      response = self.class.post(
        "/asaas/customers",
        headers: @headers,
        body: format_customer_data(customer_data).to_json
      )
      parse_response(response)
    end

    ##
    # Criação de assinatura
    # Docs: https://docs.asaas.com/reference/create-subscription
    #
    # Exemplo de subscription_data:
    # {
    #   customer: "cus_xxxxx",
    #   billingType: "BOLETO",
    #   nextDueDate: "2025-10-15",
    #   value: 19.90,
    #   cycle: "MONTHLY",
    #   description: "Plano Pro",
    #   externalReference: "sub_123"
    # }
    def create_subscription(subscription_data)
      response = self.class.post(
        "/subscriptions",
        headers: @headers,
        body: subscription_data.to_json
      )
      parse_response(response)
    end

    ##
    # Cancela assinatura
    def cancel_subscription(gateway_subscription_id)
      response = self.class.delete(
        "/subscriptions/#{gateway_subscription_id}",
        headers: @headers
      )
      parse_response(response)
    end

    # def cancel_subscription(gateway_subscription_id)
    #  puts "Cancelando subscription ASAAS: #{gateway_subscription_id}"
    #  { id: "asaas_cust_#{SecureRandom.hex(8)}",   status: "cancelled" }
    # end

    def handle_webhook(payload)
      # Normaliza eventos recebidos
      {
        event: payload["event"],
        data: payload["payment"] || payload["subscription"]
      }
    end

    private

    # Criação de cliente
    # Docs: https://docs.asaas.com/reference/create-new-customer
    #
    # Exemplo de subscription_data:
    # {
    #   "name": "Valentin Doe",
    #   "cpfCnpj": "82971563792",
    #   "email": "Valentin.doe@asaas.com.br",
    #   "phone": "4735010919",
    #   "mobilePhone": "4799376637",
    #   "address": "Av. Paulista",
    #   "addressNumber": "150",
    #   "complement": "Sala 201",
    #   "province": "Centro",
    #   "postalCode": "01310-000",
    #   "externalReference": "12987382",
    #   "notificationDisabled": false,
    #   "additionalEmailsv": "Valentin.doe@asaas.com,john.doe.silva@asaas.com.br",
    #   "municipalInscription": "46683695908",
    #   "stateInscription": "646681195275",
    #   "observations": "ótimo pagador, nenhum problema até o momento",
    #   "groupName": null,
    #   "company": null,
    #   "foreignCustomer": false
    # }
    def format_customer_data(customer_data)
      {
        name:  customer_data[:name].to_s,
        cpfCnpj: customer_data[:document].to_s,
        email: customer_data[:email].to_s,
        phone:  customer_data[:phone].to_s,
        mobilePhone: customer_data[:mobilePhone].to_s,
        postalCode: customer_data[:zip_code].to_s,
        address:  customer_data[:address].to_s,
        addressNumber: customer_data[:addressNumber].to_s,
        complement: customer_data[:complement].to_s
        # province:  customer_data[:province].to_s
      }.compact # remove chaves com valores em branco
    end


    def parse_response(response)
      if response.success?
        JSON.parse(response.body)
      else
        Rails.logger.error("Erro Asaas: #{response.code} - #{response.body}")
        raise StandardError, "Erro Asaas (#{response.code})"
      end
    end
  end
end
