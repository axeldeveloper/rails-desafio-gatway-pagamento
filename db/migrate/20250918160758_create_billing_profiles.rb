class CreateBillingProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :billing_profiles do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :gateway_customer_id
      t.string :gateway_type
      t.datetime :migrated_at

      t.timestamps
    end
    add_index :billing_profiles, [ :customer_id, :product_id, :gateway_type ], unique: true, name: "idx_unique_billing_profiles"
  end
end
