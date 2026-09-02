class AddPaidAtToPayments < ActiveRecord::Migration[8.1]
  def change
    add_column :payments, :paid_at, :datetime
  end
end
