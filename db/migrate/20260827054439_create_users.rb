class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :phone
      t.datetime :email_verified_at
      t.datetime :phone_verified_at

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
