class CreateShowSeats < ActiveRecord::Migration[8.1]
  def change
    create_table :show_seats do |t|
      t.references :show, null: false, foreign_key: true
      t.references :seat, null: false, foreign_key: true

      t.string :status, null: false, default: "AVAILABLE"
      t.datetime :held_until

      t.timestamps
    end

    add_index :show_seats, [:show_id, :seat_id], unique: true
    add_index :show_seats, :status
    add_index :show_seats, :held_until
  end
end