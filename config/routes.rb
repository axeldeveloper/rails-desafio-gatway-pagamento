Rails.application.routes.draw do
  require "sidekiq/web"
  require "sidekiq/cron/web"

  mount Rswag::Ui::Engine => "/api-docs"

  mount Rswag::Api::Engine => "/api-docs"

  mount Sidekiq::Web => "/sidekiq"


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      # Authentication routes
      post "/auth/login", to: "authentication#login"
      get "/auth/me", to: "authentication#me"


      # Gestão de clientes
      resources :customers do
        # post :migrate_from_asaas, on: :collection
        resources :payment_methods, only: [ :index, :create ]
        resources :subscriptions, only: [ :index, :create ]
        resources :invoices, only: [ :index ]
      end

      # Gestão de pagamentos
      resources :payment_methods, only: [ :show, :update, :destroy ]
      resources :subscriptions, only: [ :show, :update, :destroy ] do
        member do
          post :cancel
          # não tem assinatura reativa na pagarme
          # cancelar e criar nova
          # post :reactivate
        end
      end


      resources :invoices, only: [ :show, :update ] do
        post :capture, on: :member
        post :refund, on: :member
      end

      # Catálogo de produtos
      resources :products, only: [ :index, :show ]
      resources :plans, only: [ :index, :show ]

      # Webhooks para integração com Pagar.me e Asaas
      namespace :webhooks do
        post "asaas", to: "asaas#handle"
        post "pagarme", to: "pagarme#handle"
      end

      resources :invoices do
        member do
          post :charge
          post :cancel
        end
        resources :payments, only: [ :create, :show, :index ]
      end
    end
  end
end
