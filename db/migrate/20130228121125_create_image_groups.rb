class CreateImageGroups < ActiveRecord::Migration
  def change
    create_table :image_groups do |t|
      t.string :name
      t.integer :product_id

      t.timestamps
    end
  end
end
