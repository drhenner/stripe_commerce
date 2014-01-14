source 'http://rubygems.org'
ruby '2.0.0'

## Bundle rails:
gem 'rails', '4.0.2'
#gem 'heroku-api'
#gem 'heroku'
#gem 'taps'

gem 'uglifier', '>= 2.4.0'
gem 'sass-rails',   '~> 4.0.0'

gem "american_date", '~> 1.0'
gem 'authlogic', github: 'binarylogic/authlogic', ref: 'e4b2990d6282f3f7b50249b4f639631aef68b939'
gem 'aws-sdk', '~> 1.8.5'
gem 'bluecloth',     '~> 2.2.0'
gem 'cancan', '~> 1.6.8'
gem 'compass', '~> 0.12.2'
gem 'compass-rails', '~> 1.1.3'
gem 'chronic', '~> 0.10.2'
#gem 'dalli'#, '~> 1.0.2'

gem 'dynamic_form'#, '~> 1.1.4'
gem "friendly_id", "~> 5.0.2"
#gem 'haml',  ">= 3.0.13"#, ">= 3.0.4"#, "2.2.21"#,
gem "gibbon", "~> 0.4.6"
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'json', '~> 1.8.0'

gem 'mandrill-api'#, :git => 'git@github.com:drhenner/mandrill-api-ruby.git'
# gem 'nested_set', '~> 1.7.0'
gem 'awesome_nested_set', '~> 3.0.0.rc.3'

gem "nifty-generators", :git => 'git://github.com/drhenner/nifty-generators.git'
gem 'nokogiri', '~> 1.6.0'
gem 'paperclip', '~> 3.4.1'
gem 'prawn', '~> 0.12.0'

gem "rails3-generators", "~> 1.0.0"
#gem "rails3-generators", :git => "https://github.com/neocoin/rails3-generators.git"
gem "rails_config"
gem 'rmagick',    :require => 'RMagick'

gem 'rake', '~> 10.1'
gem 'rubyzip'
gem 'simple_xlsx_writer'#, '~> 0.5.3'
gem 'state_machine', '~> 1.2.0'
gem 'stripe', '= 1.9.9'
#gem 'sunspot_solr'
#gem 'sunspot_rails', '~> 1.3.0rc'
gem 'will_paginate', '~> 3.0.4'
gem 'resque', require: 'resque/server'
gem 'unicorn', '~> 4.8.0'
gem 'zurb-foundation', '~> 4.3.2'

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
  gem "better_errors"
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
