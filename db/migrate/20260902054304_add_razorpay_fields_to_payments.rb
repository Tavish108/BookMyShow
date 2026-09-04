class AddRazorpayFieldsToPayments < ActiveRecord::Migration[8.1]
  def change
    add_column :payments, :razorpay_order_id, :string
    add_column :payments, :razorpay_signature, :string

    add_index :payments, :razorpay_order_id, unique: true
  end
end
