class CreateBookingSeats < ActiveRecord::Migration[8.1]
  def change
    create_table :booking_seats do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :show_seat, null: false, foreign_key: true

      t.decimal :price, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :booking_seats,
              [:booking_id, :show_seat_id],
              unique: true
  end
end