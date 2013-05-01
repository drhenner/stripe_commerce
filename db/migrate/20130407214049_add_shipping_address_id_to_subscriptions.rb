class AddShippingAddressIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :shipping_address_id, :integer
    add_index  :subscriptions, :shipping_address_id
    add_column :subscriptions, :billing_address_id, :integer
    add_index  :subscriptions, :billing_address_id
  end
end
