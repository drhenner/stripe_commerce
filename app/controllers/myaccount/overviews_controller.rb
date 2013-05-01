class Myaccount::OverviewsController < Myaccount::BaseController
  def show

  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.valid_password?(params[:old_password])
      if @user.update_attributes(params[:user])
        redirect_to myaccount_overview_url(), :notice  => "Successfully updated user."
      else
        render :edit
      end
    else
      flash[:alert] = 'Your old Password is not correct.'
      render :edit
    end
  end

  private

    def selected_myaccount_tab(tab)
      tab == 'profile'
    end
end
