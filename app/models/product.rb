class Product < ApplicationRecord
  has_many :plans, dependent: :destroy

  enum :status, {
    active: "active",
    inactive: "inactive",
    deleted: "deleted"
  }, default: "active"

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :status, inclusion: { in: %w[active inactive deleted] }
end
