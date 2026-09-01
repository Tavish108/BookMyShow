class CreateShows < ActiveRecord::Migration[8.1]
  def change
    create_table :shows do |t|
      t.references :movie, null: false, foreign_key: true
      t.references :theatre, null: false, foreign_key: true
      t.references :auditorium, null: false, foreign_key: true
      t.date :show_date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end
