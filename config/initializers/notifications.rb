ActiveSupport::Notifications.subscribe("subscription.create") do |event, start, finish, id, payload|
  Rails.logger.info "[EVENT] subscription create #{id}"
  Rails.logger.info "[EVENT] subscription create #{payload}"
  Rails.logger.info "[EVENT] subscription create #{payload[:subscription_id]} gateway_subscription_id (#{payload[:gateway_subscription_id]})"
end

ActiveSupport::Notifications.subscribe("subscription.processed") do |event, start, finish, id, payload|
  Rails.logger.info "[EVENT] subscription processed #{id})"
  Rails.logger.info "[EVENT] subscription processed #{payload}"
  Rails.logger.info "[EVENT] subscription processed #{payload[:subscription_id]} gateway_subscription_id (#{payload[:gateway_subscription_id]})"
end
