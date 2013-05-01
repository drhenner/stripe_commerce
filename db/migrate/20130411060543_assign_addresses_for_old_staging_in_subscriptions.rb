class AssignAddressesForOldStagingInSubscriptions < ActiveRecord::Migration
  def up
    Subscription.reset_column_information
    # set all the subscription for staging
    Subscription.find_each do |subscription|
      subscription.shipping_address_id ||= subscription.order_item.order.ship_address_id
      subscription.billing_address_id  ||= subscription.order_item.order.bill_address_id
      subscription.save
    end
  end

  def down
  end
end
