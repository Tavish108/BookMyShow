class AddPendingRegistrationToVerificationOtps < ActiveRecord::Migration[8.1]
  def change
    add_reference :verification_otps,
                  :pending_registration,
                  foreign_key: true

    change_column_null :verification_otps, :user_id, true

    add_index :verification_otps,
              [:pending_registration_id, :purpose]
  end
end