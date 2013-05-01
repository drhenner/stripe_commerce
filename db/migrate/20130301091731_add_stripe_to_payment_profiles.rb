class AddStripeToPaymentProfiles < ActiveRecord::Migration
  def change
    add_column :payment_profiles, :customer_token, :string, :limit => 100
  end
end
