# app/models/migration_log.rb
class MigrationLog < ApplicationRecord
  belongs_to :customer

  enum :status, { pending: 0, completed: 1, failed: 2, rolled_back: 3 }

  validates :old_gateway, :new_gateway, presence: true

  scope :recent, -> { order(migration_date: :desc) }
  scope :successful, -> { where(status: "completed") }
  scope :failed, -> { where(status: "failed") }
end
