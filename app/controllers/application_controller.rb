class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  helper_method :current_user,
                :current_user_id,
                :most_likely_user,
                :random_user,
                :session_cart,
                :is_production_simulation,
                :search_product,
                :product_types,
                :myaccount_tab,
                :select_countries,
                :in_production?,
                :display_shipping_warning?,
                :display_preorder_button?,
                :customer_confirmation_page_view,
                :recent_admin_users

  before_filter :redirect_without_www
  before_filter :secure_session
  before_filter :redirect_to_welcome
  before_filter :authenticate_if_staging

  APP_DOMAIN = 'www.ror-e.com'

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    if current_user && current_user.admin?
      flash[:alert] = 'Sorry you are not allowed to do that.'
      redirect_to :back
    else
      flash[:alert] = 'Sorry you are not allowed to do that.'
      redirect_to root_url
    end
  end

  rescue_from ActiveRecord::DeleteRestrictionError do |exception|
    #notify_airbrake(exception)
    redirect_to :back, alert: exception.message
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  private

  def product_types
    @product_types ||= ProductType.roots
  end

  def customer_confirmation_page_view
    false
  end

  def display_shipping_warning?
    false
  end

  def display_preorder_button?
    true
  end

  def authenticate_if_staging
    if Rails.env.staging?
      authenticate_or_request_with_http_basic 'Staging' do |name, password|
        name == 'ror-e' && password == 'David-san'
      end
    end
  end

  def in_production?
    Rails.env.production?
  end

  def force_ssl
    has_subdomain? && Settings.force_ssl
  end

  def redirect_without_www
    if Settings.force_ssl && !/^www/.match(request.host) && (Rails.env == 'staging' || Rails.env == 'production')
        redirect_to "https://www." + request.host_with_port + request.fullpath
    elsif Settings.force_ssl && (Rails.env == 'staging' || Rails.env == 'production') && !request.ssl?
        redirect_to "https://" + request.host_with_port + request.fullpath
    end
  end

  def has_subdomain?
    request.subdomain.present? && request.subdomain == "www" # right now only allow www
  end

  def pagination_page
    params[:page] ||= 1
    params[:page].to_i
  end

  def pagination_rows
    params[:rows] ||= 20
    params[:rows].to_i
  end

  def myaccount_tab
    false
  end

  def redirect_to_welcome
    if Settings.in_signup_period
      redirect_to root_url unless current_user && current_user.admin?
    end
  end

  def redirect_unless_preorder
    redirect_to_welcome unless Settings.allow_preorders
  end

  def require_user
    redirect_to login_url and store_return_location and return if logged_out?
  end

  def store_return_location
    # disallow return to login, logout, signup pages
    disallowed_urls = [ login_url, logout_url ]
    disallowed_urls.map!{|url| url[/\/\w+$/]}
    unless disallowed_urls.include?(request.url)
      session[:return_to] = request.url
    end
  end

  def logged_out?
    !current_user
  end

  def search_product
    @search_product || Product.new
  end

  def is_production_simulation
    false
  end

  def secure_session
    if Rails.env == 'production' || is_production_simulation
      if session_cart && !request.ssl?
        cookies[:insecure] = true
      else
        cookies[:insecure] = false
      end
    else
      cookies[:insecure] = false
    end
  end

  def session_cart
    return @session_cart if defined?(@session_cart)
    session_cart!
  end
  # use this method if you want to force a SQL query to get the cart.
  def session_cart!
    if cookies[:cart_id]
      @session_cart = Cart.includes({:shopping_cart_items => {:variant => [:product, :image_group]}}).find_by_id(cookies[:cart_id])
      unless @session_cart
        @session_cart = Cart.create(:user_id => current_user_id)
        cookies[:cart_id] = @session_cart.id
      end
    elsif current_user && current_user.current_cart
      @session_cart = current_user.current_cart
      cookies[:cart_id] = @session_cart.id
    else
      @session_cart = Cart.create
      cookies[:cart_id] = @session_cart.id
    end
    @session_cart
  end
  ## The most likely user can be determined off the session / cookies or for now lets grab a random user
  #   Change this method for showing products that the end user will more than likely like.
  #
  def most_likely_user
    current_user ? current_user : random_user
  end

  ## TODO cookie[:hadean_user_id] value needs to be encrypted ### Authlogic persistence_token might work here
  def random_user
    return @random_user if defined?(@random_user)
    @random_user = cookies[:hadean_uid] ? User.find_by_persistence_token(cookies[:hadean_uid]) : nil
  end

  ###  Authlogic helper methods
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def checkout_user
    return @current_user if defined?(@current_user)
    return @checkout_user if defined?(@checkout_user)
    @checkout_user = checkout_user_session && checkout_user_session.record
  end

  def checkout_user_session
    if checkout_user_session_id
      User.find(checkout_user_session_id)
    end
  end

  def checkout_user_session_id
    session[:checkout_user_id]
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def current_user_id
    return @current_user_id if defined?(@current_user_id)
    @current_user_id = current_user_session && current_user_session.record && current_user_session.record.id
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def select_countries
    @select_countries ||= Country.landing_page_form_selector
  end

  def cc_params
    {
          :brand              => params[:type],
          :number             => params[:number],
          :verification_value => params[:verification_value],
          :month              => params[:month],
          :year               => params[:year],
          :first_name         => params[:first_name],
          :last_name          => params[:last_name]
    }
  end

  def recent_admin_users
    session[:recent_users] ||= []
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
