# lib/tasks/swagger.rake
namespace :swagger do
  desc "Generate Swagger documentation"
  task generate: :environment do
    require "rswag/api"
    require "rswag/ui"

    RSwag::Api.configure do |c|
      c.openapi_root = Rails.root.join("swagger").to_s
    end

    RSwag::Ui.configure do |c|
      c.openapi_endpoint "/api-docs/v1/swagger.yaml", "API V1 Docs"
    end

    puts "Generating Swagger documentation..."
    RSpec::Core::Runner.run([ "spec/requests", "--format", "Rswag::Specs::SwaggerFormatter" ])
    puts "Swagger documentation generated successfully!"
  end
end
