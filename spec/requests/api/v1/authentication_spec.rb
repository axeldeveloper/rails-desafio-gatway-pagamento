# spec/requests/authentication_spec.rb
require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/api/v1/auth/login' do
    post 'Login de usuário' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }

      response '200', 'login successful' do
        let(:user) { create(:user, email: 'test@example.com', password: 'password') }
        let(:credentials) { { email: user.email, password: 'password' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['token']).to be_present
          expect(data['user']['email']).to eq(user.email)
        end
      end

      response '401', 'invalid credentials' do
        let(:credentials) { { email: 'wrong@example.com', password: 'wrong' } }
        run_test!
      end
    end
  end

  path '/api/v1/auth/me' do
    get 'Obter informações do usuário atual' do
      tags 'Authentication'
      security [ Bearer: [] ]

      response '200', 'user information' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['user']['email']).to eq(user.email)
        end
      end

      response '401', 'not authenticated' do
        let(:Authorization) { 'Bearer invalid' }
        run_test!
      end
    end
  end
end
