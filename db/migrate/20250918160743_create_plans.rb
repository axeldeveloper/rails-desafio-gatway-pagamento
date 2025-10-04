class CreatePlans < ActiveRecord::Migration[8.0]
  def change
     create_table :plans do |t|
      t.string  :name, null: false
      t.string  :description
      t.string  :interval, null: false, default: "month" # day, week, month, year
      t.integer :interval_count, null: false, default: 1
      t.string  :billing_type, null: false, default: "prepaid" # prepaid, postpaid, exact_day
      t.jsonb   :payment_methods, default: [] # ["credit_card", "boleto", "debit_card"]
      t.integer :trial_period_days, default: 0
      t.integer :minimum_price_cents, default: 0
      t.string  :status, null: false, default: "active" # active, inactive, deleted
      t.jsonb :external_ids, default: {} # store pagarme_plan_id
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end
  end
end
