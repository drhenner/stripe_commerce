class CreateUsersNewsletters < ActiveRecord::Migration
  def change
    create_table :users_newsletters do |t|
      t.integer :user_id,       :null => false
      t.integer :newsletter_id, :null => false

      t.datetime :updated_at,   :null => false
    end
    add_index  :users_newsletters, :user_id
    add_index  :users_newsletters, :newsletter_id
  end
end
