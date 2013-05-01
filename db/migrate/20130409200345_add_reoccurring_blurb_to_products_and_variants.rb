class AddReoccurringBlurbToProductsAndVariants < ActiveRecord::Migration
  def change
    add_column :products, :reoccurring_blurb, :text
    add_column :variants, :reoccurring_blurb, :text
  end
end
