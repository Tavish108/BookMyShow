class CreateVerificationOtps < ActiveRecord::Migration[8.1]
  def change
    create_table :verification_otps do |t|
      t.references :user, null: false, foreign_key: true

      t.string :otp_digest, null: false
      t.string :purpose, null: false
      t.datetime :expires_at, null: false
      t.datetime :verified_at
      t.integer :attempts, null: false, default: 0

      t.timestamps
    end

    add_index :verification_otps, :purpose
    add_index :verification_otps, :expires_at
  end
end