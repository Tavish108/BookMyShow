class AddPhoneToPendingRegistrations < ActiveRecord::Migration[8.1]
  def change
    add_column :pending_registrations, :phone, :string
  end
end
