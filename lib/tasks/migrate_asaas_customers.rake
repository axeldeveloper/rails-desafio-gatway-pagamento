# lib/tasks/migrate_asaas_customers.rake
namespace :migration do
  desc "Migrate customers from ASAAS to Pagar.me"
  task asaas_to_pagarme: :environment do
    migration_service = Migration::AsaasToPagarmeService.new
    asaas_customer_ids = Customer.where("gateway_metadata->>'gateway' = ?", "asaas").pluck(:gateway_id)

    asaas_customer_ids.each do |asaas_id|
      begin
        puts "Migrating customer: #{asaas_id}"
        migration_service.migrate_customer(asaas_id)
        puts "Successfully migrated customer: #{asaas_id}"
      rescue => e
        puts "Failed to migrate customer #{asaas_id}: #{e.message}"
        # Registrar falha para reprocessamento posterior
      end
    end
  end
end
