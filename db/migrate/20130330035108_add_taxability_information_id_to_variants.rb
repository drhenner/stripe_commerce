class AddTaxabilityInformationIdToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :taxability_information_id, :integer, :default => 1 # set default so there are no nil values (postgres will fail otherwise)
    change_column(:variants, :taxability_information_id, :integer, :default => nil, :null => false)
    add_index  :variants, :taxability_information_id
  end
end
