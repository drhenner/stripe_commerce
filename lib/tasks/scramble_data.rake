namespace :rore do
  namespace :users do
    # rake rore:users:reset_tokens --trace
    task :reset_tokens => :environment  do |t,args|
      raise error #if Rails.env != 'development'
      User.all.each do |user|
        customer = Stripe::Customer.create(:description => user.name, :email => user.email)
        user.stripe_customer_token = customer.id
        user.save
      end
    end
    # rake rore:users:reset_dev_tokens --trace
    task :reset_dev_tokens => :environment  do |t,args|
      raise error if Rails.env != 'development'
      customer = Stripe::Customer.create(:description => 'Not Real', :email => 'fakeemail@velcromagnet.com')
      PaymentProfile.all.each do |pp|
        pp.customer_token = customer.id
        pp.save
      end
    end
    # rake rore:users:reset_dev_passwords --trace
    task :reset_dev_passwords => :environment  do |t,args|
      raise error if Rails.env != 'development'
      User.all.each do |user|
        user.password               = 'test123'
        user.password_confirmation  = 'test123'
        user.save
      end
    end
    # rake rore:users:reset_dev_user_info --trace
    task :reset_dev_user_info => :environment  do |t,args|
      raise error if Rails.env != 'development'
      fake = 'fake'
      email_add = '@velcromagnet.com'
      User.all.each_with_index do |user, i|
        if !user.admin?
          user.first_name = ['Scooby', 'Batman', 'Boy', 'Super', 'Clark', 'john', 'Fred', 'Barney', 'Wilma', 'Betty', 'Bruce','Captain', 'Mickey', 'Kermit'].sample
          user.last_name = ['Doo', 'Batman', 'Wonder', 'Kent', 'Kennedy', 'Wayne', 'Flintstone', 'Rubble', 'Reed', 'Kirk', 'Mouse', 'The Frog'].sample
          user.email               = fake + "#{i}" + email_add
          user.password               = 'test123'
          user.password_confirmation  = 'test123'
          unless user.save
            puts user.errors.inspect
            puts '------------'
          end
        end
      end
      Address.all.each_with_index do |address, i|
        address.first_name = ['Scooby', 'Batman', 'Boy', 'Super', 'Clark', 'john', 'Fred', 'Barney', 'Wilma', 'Betty', 'Bruce','Captain', 'Mickey', 'Kermit'].sample
        address.last_name = ['Doo', 'Batman', 'Wonder', 'Kent', 'Kennedy', 'Wayne', 'Flintstone', 'Rubble', 'Reed', 'Kirk', 'Mouse', 'The Frog'].sample
        address.zip_code = '90210'
        address.address1 = 'Sunset Blvd'
        address.address2 = ''
        address.save
      end
      Order.update_all("email = 'nota@realemail.com'")

      u = User.create(:email => 'test@velcromagnet.com', :first_name => 'Test', :last_name => 'Admin', :password => 'admin123',:password_confirmation => 'admin123' )
      u.role_ids = Role.all.map(&:id)
      u.save
    end
  end
end
