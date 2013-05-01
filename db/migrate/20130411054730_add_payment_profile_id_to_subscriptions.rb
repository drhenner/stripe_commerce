class AddPaymentProfileIdToSubscriptions < ActiveRecord::Migration
  def up
    add_column :subscriptions, :payment_profile_id, :integer
    add_index :subscriptions, :payment_profile_id
    Subscription.reset_column_information
    # set all the subscription for staging
    Subscription.find_each do |subscription|
      subscription.payment_profile_id = subscription.order_item.order.payment_profile_id
      subscription.save
    end
  end

  def down
    remove_column :subscriptions, :payment_profile_id
    remove_index :subscriptions, :payment_profile_id
  end
end
