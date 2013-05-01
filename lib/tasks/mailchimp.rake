namespace :mailchimp do
  task :subscribe_users_to_newsletters => :environment do
    User.all.each do |user|
      user.send(:subscribe_to_newsletters)
    end
  end
end
