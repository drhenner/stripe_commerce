class AddPaymentMethodIdToOrders < ActiveRecord::Migration
  def change
    add_column  :orders, :payment_profile_id, :integer
    add_index   :orders, :payment_profile_id
  end
end
