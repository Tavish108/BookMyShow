class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :booking, null: false, foreign_key: true

      t.string :status, null: false, default: "PENDING"
      t.string :payment_method
      t.string :transaction_id

      t.decimal :amount, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :payments, :status
    add_index :payments, :transaction_id, unique: true
  end
end