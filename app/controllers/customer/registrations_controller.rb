class Customer::RegistrationsController < ApplicationController
  skip_before_filter :redirect_to_welcome

  def index
    redirect_to :action => :new
  end

  def new
    @registration = true
    @user         = User.new
    @user_session = UserSession.new
    render :template => 'user_sessions/new'
  end

  def create
    @user = User.get_new_user(params[:user])
    @user.format_birth_date(params[:user][:birth_date]) if params[:user][:birth_date].present?
    # Saving without session maintenance to skip
    # auto-login which can't happen here because
    # the User has not yet been activated

    @user.name_required = true
    if agreed_to_terms? && @user.save#_without_session_maintenance
      Resque.enqueue(Jobs::SendRegistrationEmail, @user.id)
      @user.active? || @user.activate!
      @user_session = UserSession.new(:email => params[:user][:email], :password => params[:user][:password])
      @user_session.save
      cookies[:hadean_uid] = @user.access_token
      session[:authenticated_at] = Time.now
      cookies[:insecure] = false
      flash[:notice] = "Your account has been created. "
      redirect_back_or_default root_url
    else
      @user.valid?
      flash[:terms_alert] = "Please agree to the term of service to proceed." unless agreed_to_terms?
      @registration = true
      @user_session = UserSession.new
      render :template => 'user_sessions/new'
    end
  end

  private

    def agreed_to_terms?
      params[:terms] && params[:terms] == 'true'
    end

end
