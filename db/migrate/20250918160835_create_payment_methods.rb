class CreatePaymentMethods < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_methods do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :kind # 'card', 'boleto', ...
      t.jsonb :external_ids, default: {}, null: false # { pagarme_card_id: "..."}
      t.boolean :default, default: false
      t.jsonb :metadata, default: {}
      t.integer :status, default: 0
      t.timestamps
    end
    add_index :payment_methods, :external_ids, using: :gin
    add_index :payment_methods, [ :customer_id, :kind ], unique: true
  end
end
