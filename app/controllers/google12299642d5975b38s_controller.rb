class Google12299642d5975b38sController < ApplicationController
  skip_before_filter :redirect_to_welcome
  def show
    render :layout => 'raw'
  end

end
