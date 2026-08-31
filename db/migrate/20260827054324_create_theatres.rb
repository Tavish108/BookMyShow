class CreateTheatres < ActiveRecord::Migration[8.1]
  def change
    create_table :theatres do |t|
      t.string :name, null: false
      t.string :address
      t.string :city, null: false
      t.string :state
      t.string :postal_code
      t.string :phone
      t.string :email
      t.string :status, null: false

      t.timestamps
    end

    add_index :theatres, :city
    add_index :theatres, :status
  end
end
