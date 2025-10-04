class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  #
  #
  # Máx 3 tentativas, espera 5 minutos entre elas
  # retry_on StandardError, wait: 5.minutes, attempts: 3
  retry_on Common::ErrorLoadingSite, wait: 5.minutes, queue: :low_priority

  rescue_from ActiveJob::DeserializationError do |exception|
    Rails.logger.error "Deserialization error in job #{self.class.name}: #{exception.message}"
  end
end
