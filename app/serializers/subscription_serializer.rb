class SubscriptionSerializer
  include JSONAPI::Serializer

  set_type :subscription
  set_key_transform :camel_lower

  attributes :gateway_subscription_id, :status, :started_at, :ended_at,
             :created_at, :updated_at

  # CORREÇÃO: belongs_to em vez de has_many para plan
  belongs_to :billing_profile, serializer: BillingProfileSerializer
  belongs_to :plan, serializer: PlanSerializer
  # has_many :plan, lazy_load_data: true
end
