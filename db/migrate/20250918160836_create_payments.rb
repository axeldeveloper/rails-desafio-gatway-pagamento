class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :billing_profile, null: false, foreign_key: true
      t.string :gateway_payment_id
      t.integer :amount_cents
      t.integer :status
      t.integer :payment_method
      t.datetime :processed_at

      t.timestamps
    end
    add_index :payments, :gateway_payment_id, unique: true
  end
end
