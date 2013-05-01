class CreateTaxabilityInformations < ActiveRecord::Migration
  def change
    create_table :taxability_informations do |t|
      t.string :name
      t.string :code
    end
  end
end
