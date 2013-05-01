class UsersController < ApplicationController
  skip_before_filter :redirect_to_welcome
  def create
    @user = User.new(params[:user])
    # Saving without session maintenance to skip
    # auto-login which can't happen here because
    # the User has not yet been activated
    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      respond_to do |format|
        format.json { render :json => @user.to_json }
      end
    else
      Signup.create(:email => @user.email ) if @user.errors[:email].blank?
      x = @user.errors.messages.inject({}) do|ss, hh|
        ss[hh.first] = hh.last.first if hh.last.first
        ss
      end
      respond_to do |format|
        format.json { render :json => {:errors => x.to_json} }
      end
    end
  rescue PG::Error => e
    #: ERROR: duplicate key value violates unique constraint "index_users_on_email"
    # DETAIL: Key (email)=(jhan2k11@hotmail.com) already exists
    if e.message.include?('index_users_on_email')
      respond_to do |format|
        format.json { render :json => {:errors => {1 => 'Email Address already exists'}.to_json} }
      end
    else
      notify_airbrake(e)
      respond_to do |format|
        format.json { render :json => {:errors => {1 => 'Sorry an error has occured'}.to_json} }
      end
    end
  end
end
