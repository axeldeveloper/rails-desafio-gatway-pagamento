class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :billing_profile, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      # t.references :product, null: false, foreign_key: true
      t.references :payment_method
      t.string :gateway_subscription_id
      t.integer :status # active, canceled, past_due, pending
      t.jsonb :external_ids, default: {} # { pagarme_subscription_id: "..." }
      t.datetime :started_at
      t.datetime :ended_at
      # t.datetime :current_period_start
      # t.datetime :current_period_end
      # t.datetime :cancel_at_period_end


      t.timestamps
    end
    add_index :subscriptions, :gateway_subscription_id, unique: true
    add_index :subscriptions, :external_ids, using: :gin
    # add_index :subscriptions, [:customer_id]
  end
end
