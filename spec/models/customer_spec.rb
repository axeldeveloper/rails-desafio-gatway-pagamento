require 'rails_helper'

require 'rails_helper'


# docker compose run --rm web bundle exec rspec spec/models/customer_spec.rb


RSpec.describe Customer, type: :model do
  describe 'validations' do
    subject { build(:customer) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:document) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:document) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
  end

  describe 'associations' do
    it { should have_many(:billing_profiles).dependent(:destroy) }
    it { should have_many(:subscriptions).through(:billing_profiles) }
  end

  # describe 'enums' do
  #  it { should define_enum_for(:status).with_values(active: 0, inactive: 1, suspended: 2) }
  # end

  describe 'callbacks' do
    it 'normalizes email to lowercase' do
      customer = create(:customer, email: 'TEST@EMAIL.COM')
      expect(customer.email).to eq('test@email.com')
    end

    it 'formats document removing special characters' do
      customer = create(:customer, document: '123.456.789-01')
      expect(customer.document).to eq('12345678901')
    end
  end

  describe '#document_type' do
    it 'returns cpf for 11 digits' do
      customer = build(:customer, document: '12345678901')
      expect(customer.document_type).to eq('cpf')
    end

    it 'returns cnpj for 14 digits' do
      customer = build(:customer, document: '12345678000195')
      expect(customer.document_type).to eq('cnpj')
    end
  end
end
