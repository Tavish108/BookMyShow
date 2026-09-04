class AddOtpSentAtToPendingRegistrations < ActiveRecord::Migration[8.1]
  def change
    add_column :pending_registrations, :otp_sent_at, :datetime
  end
end
