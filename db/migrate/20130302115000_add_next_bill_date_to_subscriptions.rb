class AddNextBillDateToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :next_bill_date,     :date
    add_column :subscriptions, :failed_attempts,    :integer, :default => 0
    add_column :subscriptions, :canceled,           :boolean, :default => false
    add_index  :subscriptions, :next_bill_date


    add_column :subscriptions,    :remaining_payments, :integer, :default => 1
    change_column :subscriptions, :remaining_payments, :integer, :null => false
  end
end
