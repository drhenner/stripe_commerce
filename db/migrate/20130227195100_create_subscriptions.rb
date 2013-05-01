class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :subscription_plan_id, :null => false
      t.integer :user_id,              :null => false
      t.integer :order_item_id
      t.string :stripe_customer_token#, :null => false
      t.integer :total_payments
      t.boolean :active,                :default => false

      t.timestamps
    end
    add_index :subscriptions, :subscription_plan_id
    add_index :subscriptions, :user_id
    add_index :subscriptions, :order_item_id
  end
end
