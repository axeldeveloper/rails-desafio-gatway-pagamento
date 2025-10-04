# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Billing Gateway API',
        version: 'v1',
        description: 'Sistema Unificado de Cobrança - V1',
        contact: {
          name: 'Billing Team',
          email: 'billing@company.com'
        }
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          description: 'Development server',
          variables: {
            protocol: {
              #  enum: %w[http https],
              default: 'http'
            },
            defaultHost: {
              # default: 'www.example.com'
              default: 'localhost:3000'
            }
          }
        }
      ],
      components: {

        securitySchemes: {
          Bearer: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT,
            description: 'Token JWT obtido no login (Bearer token)'
          }
        },

        # securitySchemes: {
        #   ApiKeyAuth: {
        #     type: :apiKey,
        #     in: :header,
        #     name: 'Authorization',
        #     description: 'API Key authentication (Bearer token)'
        #   }
        # },
        schemas: {
          Customer: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'João Silva' },
              email: { type: :string, example: 'joao@email.com' },
              document: { type: :string, example: '12345678901' },
              phone: { type: :string, example: '11999999999' },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            },
            required: [ :name, :email, :document ]
          },
          Product: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'PMS Pro' },
              code: { type: :string, example: 'pms_pro' },
              description: { type: :string, example: 'Sistema de gestão hoteleira' },
              status: { type: :string, enum: [ 'active', 'inactive' ], example: 'active' }
            }
          },
          Plan: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'Plano Mensal PMS' },
              amount_cents: { type: :integer, example: 9900 },
              billing_type: { type: :string, enum: [ 'recurring', 'one_time' ] },
              interval: { type: :string, enum: [ 'monthly', 'quarterly', 'yearly' ] },
              product_id: { type: :integer, example: 1 }
            }
          },
          Subscription: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              status: { type: :string, enum: [ 'pending', 'active', 'cancelled', 'expired' ] },
              gateway_subscription_id: { type: :string, example: 'sub_123abc' },
              started_at: { type: :string, format: 'date-time' },
              ended_at: { type: :string, format: 'date-time', nullable: true },
              plan: { '$ref': '#/components/schemas/Plan' },
              billing_profile: { '$ref': '#/components/schemas/BillingProfile' }
            }
          },
          BillingProfile: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              gateway_customer_id: { type: :string, example: 'cust_123abc' },
              gateway_type: { type: :string, example: 'pagarme' },
              customer: { '$ref': '#/components/schemas/Customer' },
              product: { '$ref': '#/components/schemas/Product' }
            }
          },
          Invoice: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              amount_cents: { type: :integer, example: 9900 },
              due_date: { type: :string, format: 'date' },
              status: { type: :string, enum: [ 'pending', 'paid', 'overdue', 'cancelled' ] },
              gateway_invoice_id: { type: :string, example: 'inv_123abc' },
              items: {
                type: :array,
                items: { '$ref': '#/components/schemas/InvoiceItem' }
              }
            }
          },
          InvoiceItem: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              description: { type: :string, example: 'Plano PMS Pro - Janeiro/2024' },
              amount_cents: { type: :integer, example: 9900 },
              quantity: { type: :integer, example: 1 },
              product: { '$ref': '#/components/schemas/Product' }
            }
          },
          Payment: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              gateway_payment_id: { type: :string, example: 'pay_123abc' },
              amount_cents: { type: :integer, example: 9900 },
              status: { type: :string, enum: [ 'pending', 'processing', 'paid', 'failed', 'refunded' ] },
              payment_method: { type: :string, enum: [ 'credit_card', 'pix', 'boleto' ] },
              processed_at: { type: :string, format: 'date-time', nullable: true }
            }
          },
          Error: {
            type: :object,
            properties: {
              error: { type: :string, example: 'Validation failed' },
              message: { type: :string, example: 'Email is required' },
              details: { type: :object }
            }
          }
        }
      }

    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  # config.openapi_format = :yaml
  config.openapi_format = :json
end
