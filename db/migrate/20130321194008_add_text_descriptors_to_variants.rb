class AddTextDescriptorsToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :title, :string
    add_column :variants, :small_description, :string
    add_column :variants, :option_text, :string
  end
end
