class AddSaltToPaymentProfile < ActiveRecord::Migration
  def change
    add_column :payment_profiles, :salt, :string
  end
end
