FactoryBot.define do
  factory :plan do
    name { "MyString" }
    amount_cents { 1 }
    billing_type { 1 }
    interval { 1 }
    product { nil }
    created_at { "2025-09-18 13:07:43" }
    updated_at { "2025-09-18 13:07:43" }
  end
end
