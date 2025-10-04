# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-cron"

redis_config = { url: ENV.fetch("SIDEKIQ_REDIS_URL", "redis://localhost:6379/0") }

Sidekiq.configure_server do |config|
  config.redis = redis_config

  config.on(:startup) do
    schedule_file = Rails.root.join("config/sidekiq.yml")

    if File.exist?(schedule_file)
      sidekiq_yml = YAML.load_file(schedule_file)
      if sidekiq_yml[:cron] || sidekiq_yml["cron"]
        cron_jobs = sidekiq_yml[:cron] || sidekiq_yml["cron"]
        Sidekiq::Cron::Job.load_from_hash(cron_jobs)
        Rails.logger.info "✅ Sidekiq-cron carregou os jobs: #{cron_jobs.keys.join(', ')}"
      else
        Rails.logger.warn "⚠️ Nenhum cron encontrado no sidekiq.yml"
      end
    end
  end
end



# Sidekiq.configure_server do |config|
#   config.redis = redis_config
#   config.average_scheduled_poll_interval = 1
#   config.on(:startup) do
#     schedule_file = Rails.root.join("config/sidekiq.yml")

#     if File.exist?(schedule_file)
#       sidekiq_yml = YAML.load_file(schedule_file)

#       if sidekiq_yml["cron"]
#         Sidekiq::Cron::Job.load_from_hash(sidekiq_yml["cron"])
#         Rails.logger.info "[Sidekiq] Cron jobs carregados: #{sidekiq_yml['cron'].keys.join(', ')}"
#       end
#     end
#   end
# end


Sidekiq.configure_client do |config|
  config.redis = redis_config
end
