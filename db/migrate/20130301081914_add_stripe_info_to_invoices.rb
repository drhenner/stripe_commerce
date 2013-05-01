class AddStripeInfoToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :card_token, :string, :limit => 100
    add_column :invoices, :tax_amount, :integer
    add_column :invoices, :tax_state_id, :integer
    #add_column :invoices, :token_amount, :integer
    add_column :invoices, :charge_token, :string, :limit => 100
    add_column :invoices, :customer_token, :string, :limit => 100

    add_column :transaction_ledgers, :tax_state_id, :integer
  end
end

