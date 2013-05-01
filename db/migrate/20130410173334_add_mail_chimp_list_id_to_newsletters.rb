class AddMailChimpListIdToNewsletters < ActiveRecord::Migration
  def change
    add_column :newsletters, :mailchimp_list_id, :string
  end
end
