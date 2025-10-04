# app/models/payment_method.rb
class PaymentMethod < ApplicationRecord
  belongs_to :customer


  enum :kind, {
    credit_card: "credit_card",
    boleto: "boleto",
    cash: "cash",
    debit_card: "debit_card",
    pix: "pix"
  }, default: "boleto"

  validates :kind, presence: true

  validates :kind, uniqueness: { scope: :customer_id }

  store_accessor :external_ids, :pagarme_payment_method_id, :asaas_payment_method_id

  # 🔹 Scope para buscar único por customer + kind
  scope :for_customer_and_kind, ->(customer_id, kind) {
    where(customer_id: customer_id, kind: kind).limit(1)
  }
end
