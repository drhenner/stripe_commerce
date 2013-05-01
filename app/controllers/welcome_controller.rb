class WrongSettingsError < StandardError ; end
class WelcomeController < ApplicationController
  skip_before_filter :redirect_to_welcome
  layout 'application'

  def index
    @user = User.new
    if Settings.in_signup_period
      if current_user && current_user.admin?
        render  :layout => 'preorder'
      else
        render :template => 'welcome/signup', :layout => 'welcome'
      end
    elsif Settings.allow_orders
      render :template => 'welcome/orders', :layout => 'application'
    elsif Settings.allow_preorders
      render  :layout => 'preorder'
    else
      raise WrongSettingsError
    end
  end

  def load
    if in_production?
      render :text => 'loaderio-79aeb8198cf6b8d1faffd0edad063326', :layout => false
    else#staging
      render :text => 'loaderio-93a086e0760b88038535f27e6b626d2b', :layout => false
    end
  end
end
