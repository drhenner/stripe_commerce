Hadean::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  config.force_ssl = false

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Add the fonts path
  config.assets.paths << "#{Rails.root}/app/assets/fonts"

  # Precompile additional assets
  config.assets.precompile += %w( .svg .eot .woff .ttf )
  config.assets.precompile += %w( *.js )
  config.assets.precompile += [ 'admin.css',
                                'admin/app.css',
                                'admin/cart.css',
                                'admin/foundation.css',
                                'admin/normalize.css',
                                'admin/help.css',
                                'admin/ie.css',
                                'autocomplete.css',
                                'application.css',
                                'chosen.css',
                                'foundation.css',
                                "font-awesome-social.css",
                                'font-awesome.css',
                                'home_page.css',
                                'ie.css',
                                'ie6.css',
                                'jquery.titanlighbox.css',# in vendor
                                'jquery.jtweetsanywhere.css',# in vendor
                                'login.css',
                                'markdown.css',
                                'markitup/skins/markitup/style.css',
                                'markitup/skins/simple/style.css',
                                'markitup/sets/default/style.css',
                                'myaccount.css',
                                'normalize.css',
                                'pikachoose_product.css',
                                'product_page.css',
                                'products_page.css',
                                'shopping_cart_page.css',
                                'signup.css',
                                'site/app.css',
                                'site/preorder.css',
                                'site/small_welcome.css',
                                'site/temp_signup_form.css',
                                'social_foundicons.css',
                                'social_foundicons_ie7.css',
                                'sprite.css',
                                'tables.css',
                                'cupertino/jquery-ui-1.8.12.custom.css',# in vendor
                                'modstyles.css', # in vendor
                                'scaffold.css' # in vendor
                                ]

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  #if ENV['FOG_DIRECTORY'].present?
    #config.action_controller.asset_host = "https://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com"
    config.action_controller.asset_host = "https://www.rubydj.com"
  #end

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store
  config.cache_store = :dalli_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  config.action_mailer.default_url_options = { :host => 'www.rubydj.com' }
  config.action_mailer.asset_host = "https://www.rubydj.com"
  #config.action_mailer.asset_host = "//#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com"

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify


  config.after_initialize do
    Paperclip::Attachment.default_options[:storage] = :s3
  end
  PAPERCLIP_STORAGE_OPTS = {  :styles => {:mini => '48x48>',
                                          :small => '100x100>',
                                          :medium   => '200x200>',
                                          :product => '320x320>',
                                          :large => '600x600>' },
                              :default_style => :product,
                              :url => "/assets/products/:id/:style/:basename.:extension",
                              :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension" }
end
