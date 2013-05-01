class CreateSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table :subscription_plans do |t|
      t.string :name,           :null => false
      t.string :stripe_id,      :null => false# just ID @ stripe
      t.integer :amount,        :null => false
      t.integer :total_payments
      t.string :interval,       :null => false

      t.timestamps
    end
    add_index :subscription_plans, :stripe_id
  end
end
