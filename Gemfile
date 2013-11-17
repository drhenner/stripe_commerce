source 'http://rubygems.org'

## Bundle rails:
gem 'rails', '3.2.15'
#gem 'heroku-api'
#gem 'heroku'
#gem 'taps'

group :assets do
  gem 'uglifier', '>= 1.3.0'
end
  gem 'sass-rails', "  ~> 3.2.3"

gem "american_date", '~> 1.0'
gem 'authlogic'#, "3.2.0"
gem 'aws-sdk', '~> 1.8.5'
gem 'bluecloth',     '~> 2.1.0'
gem 'cancan', '~> 1.6.8'
gem 'compass', '~> 0.12.2'
gem 'compass-rails'
gem 'chronic'
gem 'dalli'#, '~> 1.0.2'

gem 'dynamic_form', '~> 1.1.4'
gem "friendly_id", "~> 3.3"
gem 'haml',  ">= 3.0.13"#, ">= 3.0.4"#, "2.2.21"#,
gem "gibbon", "~> 0.4.6"
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'json', '~>1.7.7'

gem 'mandrill-api'#, :git => 'git@github.com:drhenner/mandrill-api-ruby.git'
gem 'nested_set', '~> 1.7.0'

gem "nifty-generators", :git => 'git://github.com/drhenner/nifty-generators.git'
gem 'nokogiri', '~> 1.5.6'
gem 'paperclip', '~> 3.4.1'
gem 'prawn', '~> 0.12.0'

gem "rails3-generators", :git => "https://github.com/neocoin/rails3-generators.git"
gem "rails_config"
gem 'rmagick',    :require => 'RMagick'

gem 'rake', '~> 0.9.2'
gem 'simple_xlsx_writer', '~> 0.5.3'
gem 'state_machine', '~> 1.1.2'
gem 'stripe'
#gem 'sunspot_solr'
#gem 'sunspot_rails', '~> 1.3.0rc'
gem 'will_paginate', '~> 3.0.4'
gem 'resque', require: 'resque/server'
gem 'unicorn'

group :production, :staging do
  gem 'pg'
  gem "airbrake"
  gem 'newrelic_rpm', '~> 3.5.5.38'
  # gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
end

group :development do
  #gem 'awesome_print'
  #gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem "autotest-rails-pure"
  gem "foreman"
  gem "letter_opener"
  gem "rails-erd"
  gem "debugger"
  gem 'mysql2'

  # YARD AND REDCLOTH are for generating yardocs
  #gem 'yard'
  #gem 'RedCloth'
end
group :test, :development do
  gem 'capybara', "~> 1.1"#, :git => 'git://github.com/jnicklas/capybara.git'
  gem 'launchy'
  gem 'database_cleaner'
end

group :test do
  gem 'factory_girl', "~> 3.3.0"
  gem 'factory_girl_rails', "~> 3.3.0"
  gem 'mocha', '~> 0.13.3', :require => false
  gem 'rspec-rails-mocha'
  gem 'rspec-rails', '~> 2.12.2'

  gem 'email_spec'
  gem 'resque_spec'
  gem "faker"
  gem "autotest", '~> 4.4.6'
  gem "autotest-rails-pure"

  gem "autotest-growl"
  gem "ZenTest", '4.9.5'

end
