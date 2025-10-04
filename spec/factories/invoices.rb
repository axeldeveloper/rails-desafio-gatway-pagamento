FactoryBot.define do
  factory :invoice do
    subscription { nil }
    billing_profile { nil }
    amount_cents { 1 }
    due_date { "2025-09-18" }
    status { 1 }
    gateway_invoice_id { "MyString" }
  end
end
