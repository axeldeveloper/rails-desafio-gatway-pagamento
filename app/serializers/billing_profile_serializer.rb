class BillingProfileSerializer
  include JSONAPI::Serializer

  set_type :billing_profile
  attributes :gateway_customer_id, :gateway_type, :migrated_at
end
