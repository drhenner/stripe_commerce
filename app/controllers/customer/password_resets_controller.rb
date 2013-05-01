class Customer::PasswordResetsController < ApplicationController
    skip_before_filter :redirect_to_welcome
    before_filter :load_user_using_perishable_token, :only => [ :edit, :update ]

    def new
      @user = User.new
      render :layout => 'welcome'
    end

    def create
        @user = User.find_by_email(params[:user][:email])
        if @user && !@user.signed_up?
          @user.deliver_password_reset_instructions!
          respond_to do |format|
            format.html do
              flash[:notice] = 'Instructions to reset your password have been emailed.'
              render :template => '/customer/password_resets/confirmation'
            end
            format.json { render :json => @user.to_json }
          end
        else
          respond_to do |format|
            format.html do
              @user = User.new
              flash[:notice] = 'No registered user was found with that email address'
              render :action => 'new'
            end
            format.json { render :json => {:errors => 'No registered user was found with that email address'} }
          end
        end
    end

    def edit
      #render
    end

    def update
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      if @user.save
        #@user.activate!
        flash[:notice] = 'Your password has been reset'
        redirect_to login_url
      else
        render :action => :edit
      end
    end

    protected

    def load_user_using_perishable_token
      unless @user = User.find_by_perishable_token( params[:id])
        flash[:notice] = 'The link you used in no longer valid.  Click the password reset link to get a new link to reset your password.'
        redirect_to login_url and return
      end
    end

end
