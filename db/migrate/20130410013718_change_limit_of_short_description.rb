class ChangeLimitOfShortDescription < ActiveRecord::Migration
  def up
    change_column :variants, :small_description, :string, :limit => 500
  end

  def down
    # no down needed
  end
end
