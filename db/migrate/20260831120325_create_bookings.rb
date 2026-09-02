class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :show, null: false, foreign_key: true

      t.string :status, null: false, default: "PENDING"
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.datetime :expires_at

      t.timestamps
    end

    add_index :bookings, :status
    add_index :bookings, :expires_at
  end
end