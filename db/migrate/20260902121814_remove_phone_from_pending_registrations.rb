class RemovePhoneFromPendingRegistrations < ActiveRecord::Migration[8.1]
  def change
    remove_column :pending_registrations, :phone, :string
  end
end