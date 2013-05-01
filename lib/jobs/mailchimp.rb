module Jobs
  class SubscribeUserToMailChimpList
    @queue = :subscribe_user_to_mail_chimp_list
    def self.perform(user_id, newsletter_id)
      user = User.find(user_id)
      newsletter = Newsletter.find(newsletter_id)
      gb = Gibbon.new(Settings.mailchimp.api_key)
      gb.list_subscribe({:id => newsletter.mailchimp_list_id, :email_address => user.email, :merge_vars => {:FNAME => user.first_name, :LNAME => user.last_name}})
    end
  end
end
