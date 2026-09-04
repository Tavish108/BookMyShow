class CreatePendingRegistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :pending_registrations do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :password_digest, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :pending_registrations, :email, unique: true
    add_index :pending_registrations, :phone, unique: true
  end
end