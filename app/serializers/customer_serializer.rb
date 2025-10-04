# app/serializers/customer_serializer.rb
class CustomerSerializer
  include JSONAPI::Serializer

  set_type :customer
  set_key_transform :camel_lower

  attributes :name, :email, :document, :zip_code,
             :phone, :address, :state, :country, :city, :status



  has_many :payments, lazy_load_data: true
  has_many :invoices, lazy_load_data: true
  has_many :subscriptions, lazy_load_data: true
end
