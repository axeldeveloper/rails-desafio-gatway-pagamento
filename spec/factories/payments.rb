FactoryBot.define do
  factory :payment do
    invoice { nil }
    billing_profile { nil }
    gateway_payment_id { "MyString" }
    amount_cents { 1 }
    status { 1 }
    payment_method { 1 }
    processed_at { "2025-09-18 13:08:36" }
  end
end
