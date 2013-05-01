class ContactUsController < ApplicationController
  skip_before_filter :redirect_to_welcome
  def show
    render :nothing => true
  end

  private


end
