class UnsubscribesController < ApplicationController
  skip_before_filter :redirect_to_welcome
  def show
    UsersNewsletter.unsubscribe(params[:email], params[:key])
    render :layout => 'blank'
  end

end
