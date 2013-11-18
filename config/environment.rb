# Load the rails application
require File.expand_path('../application', __FILE__)
require File.expand_path('../../lib/printing/invoice_printer', __FILE__)

# Initialize the rails application
Hadean::Application.initialize!
Hadean::Application.configure do
  config.after_initialize do
    unless Settings.encryption_key
      raise "
      ############################################################################################
      !  You need to setup the settings.yml
      !  copy settings.yml.example to settings.yml
      !
      !  Make sure you personalize the passwords in this file and for security never check this file in.
      ############################################################################################
      "
    end
    unless Settings.stripe.secret_key
      puts "
      ############################################################################################
      ############################################################################################
      !  You need to setup the settings.yml
      !  copy settings.yml.example to settings.yml
      !
      !  YOUR ENV variables are not ready for checkout!
      !  please adjust ENV['STRIPE_SECRET_KEY'] && ENV['STRIPE_PUBLISHABLE_KEY']
      !  This is required for the checkout process to work.
      !
      !  Remove or Adjust this warning in /config/environment.rb for developers on your team
      !  once you everything working with your specific Gateway.
      ############################################################################################
      "
    end
  end
end
