class Invoice < ApplicationRecord
  belongs_to :subscription
  belongs_to :billing_profile
end
