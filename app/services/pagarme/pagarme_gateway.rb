# Implementação específica Pagar.me
module Pagarme
  class PagarmeGateway < PaymentGateway
    include HTTParty

    # base_uri "https://api.pagar.me/core/v5"
    base_uri "http://localhost:3001/"


    def initialize
      @headers = {
        "Authorization" => "Basic #{Rails.application.credentials.pagarme.secret_key}",
        "Content-Type" => "application/json"
      }
      @gateway_name = :pagarme
    end

    #
    # Criação de cliente
    # Docs: https://docs.pagar.me/reference/criar-cliente-1
    #
    # Exemplo de customer_data:

    def create_customer(customer_data)
      response = self.class.post(
        "/pagarme/customers",
        headers: @headers,
        body: format_customer_data(customer_data).to_json
      )
      handle_response(response)
    end

    def create_subscription(subscription_data)
      response = self.class.post("/subscriptions", {
        headers: @headers,
        body: format_subscription_data(subscription_data).to_json
      })

      handle_response(response)
    end


    def cancel_subscription(gateway_subscription_id, cancel_pending_invoices: true)
      response = self.class.delete(
        "/subscriptions/#{gateway_subscription_id}",
        headers: @headers,
        body: { cancel_pending_invoices: cancel_pending_invoices }.to_json
      )
      handle_response(response)
    end

    def gateway_name
      @gateway_name
    end

    private

    # Formata dados para criação de assinatura
    # mostra apenas os campos necessários para o Pagar.me
    # {
    #   "name": "Tony Stark",
    #   "email": "tonystarkk@avengers.com",
    #   "code": "MY_CUSTOMER_001",
    #   "document": "93095135270",
    #   "type": "individual",
    #   "document_type": "CPF",
    #   "gender": "male",
    #   "address": {
    #     "line_1": "375, Av. General Justo, Centro",
    #     "line_2": "8º andar",
    #     "zip_code": "20021130",
    #     "city": "Rio de Janeiro",
    #     "state": "RJ",
    #     "country": "BR"
    #   },
    #   "birthdate": "05/03/1984",
    #   "phones": {
    #     "home_phone": {
    #       "country_code": "55",
    #       "area_code": "21",
    #       "number": "000000000"
    #     },
    #     "mobile_phone": {
    #       "country_code": "55",
    #       "area_code": "21",
    #       "number": "000000000"
    #     }
    #   },
    #   "metadata": {
    #     "company": "Avengers"
    #   }
    # }
    def format_subscription_data(data)
     {
        plan_id: data[:plan_id],
        payment_method: data[:payment_method],
        customer: {
          id: data[:customer_id]
        },
        postback_url: data[:postback_url]
      }
    end

    def format_customer_data(data)
      {
        name: data[:name],
        email: data[:email],
        document: data[:document],
        document_type: data[:document_type],
        code: data[:external_id],
        type: data[:type] || "individual",

        # gender: nil, # Opcional
        # birthdate: format_birthdate(customer_params[:birthday]),
        # phones: format_phones(customer_params[:phone]),
        # address: format_address(customer_params[:address])

        phones: {
          mobile_phone: {
            country_code: "55",
            area_code: data[:phone_area_code],
            number: data[:phone_number]
          }
        }
      }
    end

    def handle_response(response)
      if response.success?
        JSON.parse(response.body)
      else
        raise Common::PaymentGatewayError, "Gateway error: #{response.body}"
      end
    end
  end
end
