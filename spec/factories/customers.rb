FactoryBot.define do
  factory :customer do
    # sequence(:external_id) { |n| "cust_#{n}_#{SecureRandom.hex(8)}" }
    name { Faker::Name.name }
    sequence(:email) { |n| "customer#{n}@example.com" }
    document_type { %w[CPF CNPJ].sample }
    document { aker::IDNumber.brazilian_citizen_number(formatted: true) }
    phone { [ Faker::PhoneNumber.cell_phone, Faker::PhoneNumber.phone_number ] }
    address { Faker::Address.street_address }
    number { Faker::Address.building_number }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip_code {  Faker::Address.postcode }
    country { 'BR' }
    status { 0 }
  end
end
