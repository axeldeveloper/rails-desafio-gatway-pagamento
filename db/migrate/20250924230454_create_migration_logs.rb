class CreateMigrationLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :migration_logs do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :old_gateway, null: false
      t.string :new_gateway, null: false
      t.string :new_gateway_customer_id
      t.datetime :migration_date
      t.integer :status, default: 0
      t.integer :profiles_migrated, default: 0
      t.datetime :rolled_back_at
      t.string :rollback_reason
      t.text :notes
      t.timestamps
    end

    add_index :migration_logs, :migration_date
    add_index :migration_logs, :status
    add_index :migration_logs, [ :customer_id, :old_gateway ]
  end
end
