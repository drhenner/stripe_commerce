class AddSubscriptionIdToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :subscription_item, :boolean
  end
end
