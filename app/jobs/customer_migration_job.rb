# Job para execução da migração
class CustomerMigrationJob < ApplicationJob
  queue_as :migration

  # Se falhar em todas as tentativas, descarta e log
  discard_on ActiveRecord::RecordNotFound do |job, error|
    Rails.logger.error "[MigrationJob] Record not found: #{error.message}, args: #{job.arguments.inspect}"
  end

  def perform(args = {})
    batch_size = args.with_indifferent_access[:batch_size] || 50
    Rails.logger.info "[MigrationJob] Iniciando migração em lote, batch_size=#{batch_size}"

    migration_service = Migration::AsaasMigrationService.new
    migration_service.migrate_customer_batch(batch_size: batch_size)

    Rails.logger.info "[MigrationJob] Migração concluída com sucesso"
  rescue => e
    Rails.logger.error "[MigrationJob] Erro durante a migração: #{e.class} - #{e.message}"
    raise # deixa o retry_on cuidar das tentativas
  end
end
