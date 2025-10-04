class Payment < ApplicationRecord
  belongs_to :invoice
  belongs_to :billing_profile

   enum payment_method: { credit_card: 0, debit_card: 1, boleto: 2, pix: 3 }
end
