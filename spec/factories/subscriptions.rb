FactoryBot.define do
  factory :subscription do
    billing_profile { nil }
    plan { nil }
    gateway_subscription_id { "MyString" }
    status { 1 }
    started_at { "2025-09-18 13:08:08" }
    ended_at { "2025-09-18 13:08:08" }
  end
end
