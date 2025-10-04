class Plan < ApplicationRecord
  belongs_to :product

  # interval  (monthly, yearly, custom)

  enum :status, {
    active: "active",
    inactive: "inactive",
    deleted: "deleted"
  }, default: "active"

  validates :name, presence: true
  validates :interval, inclusion: { in: %w[day week month year] }
  validates :billing_type, inclusion: { in: %w[prepaid postpaid exact_day] }
  validates :status, inclusion: { in: %w[active inactive deleted] }

  def price_in_reais
    minimum_price_cents.to_f / 100
  end
end
