FactoryBot.define do
  factory :invoice_item do
    invoice { nil }
    product { nil }
    description { "MyString" }
    amount_cents { 1 }
    quantity { 1 }
  end
end
