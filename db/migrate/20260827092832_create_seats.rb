class CreateSeats < ActiveRecord::Migration[8.1]
  def change
    create_table :seats do |t|
      t.references :auditorium, null: false, foreign_key: true
      t.string :row_name, null: false
      t.integer :seat_number, null: false
      t.string :seat_type
      t.string :seat_category

      t.timestamps
    end
    add_index :seats,
              [ :auditorium_id, :row_name, :seat_number ],
              unique: true
  end
end
