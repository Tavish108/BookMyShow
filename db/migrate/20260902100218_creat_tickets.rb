class CreatTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :tickets do |t|
      t.references :booking, null: false, foreign_key: true, index: { unique: true }
      t.string :ticket_number, null: false
      t.string :qr_token, null: false

      t.timestamps
    end

    add_index :tickets, :ticket_number, unique: true
    add_index :tickets, :qr_token, unique: true
  end
end
