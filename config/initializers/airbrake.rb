if Rails.env == 'production'
  Airbrake.configure do |config|
    config.api_key = ''
  end
end
if Rails.env == 'staging'
  Airbrake.configure do |config|
    config.api_key = ''
  end
end
