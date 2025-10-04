class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      # Adiciona a nova coluna JSONB
      t.jsonb :external_ids, default: {}, null: false
      t.string :name
      t.string :email
      t.string :document, null: false
      t.string :phone
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country, default: 'BR'
      t.string :status, default: :active

      t.timestamps
    end
    #   add_index :customers, :external_id, unique: true
    # Index GIN para buscas mais rápidas dentro do JSONB
    add_index :customers, :external_ids, using: :gin
    add_index :customers, :email, unique: true
    add_index :customers, :document, unique: true
  end
end
