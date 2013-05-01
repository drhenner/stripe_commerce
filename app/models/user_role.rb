class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

 # validates :user_id,  :presence => true
  validates :role_id,  :presence => true
  after_save :expire_user_roles

  private

    def expire_user_roles
      Rails.cache.delete("cached_role_ids-#{user_id}")
    end
end
