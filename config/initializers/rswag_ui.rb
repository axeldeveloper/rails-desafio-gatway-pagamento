# config/initializers/rswag_ui.rb
Rswag::Ui.configure do |c|
  # Nova sintaxe (sem warning)
  c.openapi_endpoint "/api-docs/v1/swagger.yaml", "Billing Gateway API V1 Docs"

  # Múltiplas versões (se necessário)
  # c.openapi_endpoint '/api-docs/v2/swagger.yaml', 'Billing Gateway API V2'

  # Autenticação em produção
  # if Rails.env.production?
  #   c.basic_auth_enabled = true
  #   c.basic_auth_credentials ENV.fetch("SWAGGER_USER", "admin"),
  #                           ENV.fetch("SWAGGER_PASSWORD", "password")
  # else
  #   c.basic_auth_enabled = false
  #   # c.basic_auth_credentials "admin", "password" if Rails.env.production?
  # end

  # Se precisar de autenticação
  c.basic_auth_enabled = false
  # c.basic_auth_credentials = {
  #   username: 'admin',
  #   password: 'password'
  # }

  c.config_object = {
    url: "/api-docs/v1/swagger.yaml",
    validatorUrl: nil
  }



  # Título da documentação
  # c.doc_expansion = "none"
end
