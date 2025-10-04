# spec/requests/api/v1/customers_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/customers', type: :request do
  let(:customer) { create(:customer) }
  let(:valid_token) { "Bearer #{JwtService.encode(user_id: user.id)}" }
  let(:invalid_token) { 'Bearer invalid_token' }

  path '/api/v1/customers' do
    get('Lista clientes') do
      tags 'Customers'
      security [ Bearer: [] ]
      description 'Lista todos os clientes com paginação'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, description: 'Número da página', example: 1
      parameter name: :per_page, in: :query, type: :integer, description: 'Itens por página', example: 25
      parameter name: :search, in: :query, type: :string, description: 'Busca por nome ou email'

      response(200, 'Lista de clientes recuperada com sucesso') do
        schema type: :object,
               properties: {
                 customers: {
                   type: :array,
                   items: { '$ref': '#/components/schemas/Customer' }
                 },
                 meta: {
                   type: :object,
                   properties: {
                     current_page: { type: :integer },
                     total_pages: { type: :integer },
                     total_count: { type: :integer }
                   }
                 }
               }

        let(:Authorization) { valid_token }

        before do
          create_list(:customer, 3)
        end

        run_test!
      end

      response(401, 'não autorizado') do
        schema '$ref': '#/components/schemas/Error'
        run_test!
      end
    end

    post('Criar cliente') do
      tags 'Customers'
      security [ Bearer: [] ]
      description 'Cria um novo cliente'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :customer, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'João Silva' },
          email: { type: :string, example: 'joao@email.com' },
          document: { type: :string, example: '12345678901' },
          phone: { type: :string, example: '11999999999' }
        },
        required: [ :name, :email, :document ]
      }

      response(201, 'criado') do
        schema '$ref': '#/components/schemas/Customer'

        let(:Authorization) { valid_token }
        let(:customer) { { name: 'João Silva', email: 'joao@test.com', document: '12345678901' } }
        run_test!
      end

      response '401', 'Não autorizado' do
        let(:Authorization) { invalid_token }
        run_test!
      end

      response(422, 'dados inválidos') do
        schema '$ref': '#/components/schemas/Error'

        let(:Authorization) { invalid_token  }
        let(:customer) { { name: '', email: 'invalid' } }
        run_test!
      end
    end
  end

  path '/api/v1/customers/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'ID do cliente'

    get('Mostrar cliente') do
      tags 'Customers'
      produces 'application/json'
      security [ Bearer: [] ]

      response(200, 'sucesso') do
        schema '$ref': '#/components/schemas/Customer'

        let(:Authorization) { valid_token }
        let(:id) { '1' }
        run_test!
      end

      response(404, 'não encontrado') do
        schema '$ref': '#/components/schemas/Error'

        let(:Authorization) { invalid_token }
        let(:id) { '999' }
        run_test!
      end
    end

    put('Atualizar um cliente') do
      tags 'Customers'
      security [ Bearer: [] ]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :customer, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          document: { type: :string },
          phone: { type: :string },
          address: { type: :string },
          number: { type: :string },
          city: { type: :string },
          state: { type: :string },
          zip_code: { type: :string },
          country: { type: :string }
        }
      }

      response '200', 'Cliente atualizado' do
        let(:Authorization) { valid_token }
        let(:customer_obj) { create(:customer) }
        let(:id) { customer_obj.id }
        let(:customer) { { name: 'Novo Nome' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('Novo Nome')
        end
      end

      response '401', 'Não autorizado' do
        let(:Authorization) { invalid_token }
        let(:id) { 1 }
        let(:customer) { { name: 'Test' } }
        run_test!
      end
    end

    delete 'Excluir um cliente' do
      tags 'Customers'
      security [ Bearer: [] ]

      parameter name: :id, in: :path, type: :integer, required: true

      response '204', 'Cliente excluído' do
        let(:Authorization) { valid_token }
        let(:customer) { create(:customer) }
        let(:id) { customer.id }

        run_test!
      end

      response '401', 'Não autorizado' do
        let(:Authorization) { invalid_token }
        let(:id) { 1 }
        run_test!
      end
    end
  end
end
