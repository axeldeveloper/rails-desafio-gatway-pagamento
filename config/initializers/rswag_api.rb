# config/initializers/rswag_api.rb
Rswag::Api.configure do |c|
  # Diretório dos arquivos swagger
  # c.openapi_root = Rails.root.join("swagger").to_s
  c.openapi_root = Rails.root.to_s + "/swagger"

   c.swagger_headers = { "Accept" => "application/json" }

  # Configurar filtro CORS para desenvolvimento
  # c.swagger_filter = lambda { |swagger, env| swagger }


  # Filtro para CORS e customizações
  c.swagger_filter = lambda { |swagger, env|
    # Adicionar headers CORS em desenvolvimento
    # if Rails.env.development?
    #   swagger["servers"] ||= []
    #   swagger["servers"] << {
    #     "url" => "http://localhost",
    #     "description" => "Development server"
    #   }
    # end

    # Adicionar informações de segurança
    # swagger["components"] ||= {}

    # swagger["components"]["securitySchemes"] ||= {
    #   "ApiKeyAuth" => {
    #     "type" => "apiKey",
    #     "in" => "header",
    #     "name" => "Authorization",
    #     "description" => "API Key authentication (Bearer token)"
    #   }
    # }
    swagger["host"] = env["HTTP_HOST"]
    # swagger
  }
end
