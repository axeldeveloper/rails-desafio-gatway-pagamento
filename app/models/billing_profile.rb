class BillingProfile < ApplicationRecord
  belongs_to :customer
  belongs_to :product
  has_many :subscriptions

  validates :gateway_customer_id, presence: true

  validates :gateway_type, uniqueness: { scope: [ :customer_id, :product_id, :gateway_customer_id ] }
end
