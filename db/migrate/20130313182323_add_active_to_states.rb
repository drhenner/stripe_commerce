class AddActiveToStates < ActiveRecord::Migration
  def change
    add_column :states, :active, :boolean, :default => true
  end
end
