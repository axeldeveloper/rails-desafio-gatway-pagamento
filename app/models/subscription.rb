class Subscription < ApplicationRecord
  belongs_to :billing_profile
  belongs_to :plan
  has_many :invoices


  enum :status, { active: 0, canceled: 1, expired: 2, pending: 3 }, default: :active

  store_accessor :external_ids, :pagarme_subscription_id, :asaas_psubscription_id
end
