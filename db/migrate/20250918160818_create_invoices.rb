class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.references :subscription, null: false, foreign_key: true
      t.references :billing_profile, null: false, foreign_key: true
      t.integer :amount_cents
      t.date :due_date
      t.integer :status
      t.string :gateway_invoice_id

      t.timestamps
    end
  end
end
