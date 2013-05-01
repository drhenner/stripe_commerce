class AddSubscriptionPlanIdToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :subscription_plan_id, :integer
    add_index :variants, :subscription_plan_id
  end
end
