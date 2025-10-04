FactoryBot.define do
  factory :billing_profile do
    customer { nil }
    product { nil }
    gateway_customer_id { "MyString" }
    gateway_type { "MyString" }
    migrated_at { "2025-09-18 13:07:58" }
  end
end
