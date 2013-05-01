class AddTaxAmountToReturnAuthorizations < ActiveRecord::Migration
  def change
    add_column :return_authorizations, :tax_amount, :integer
  end
end
