class FaqsController < ApplicationController
  skip_before_filter :redirect_to_welcome
  def index
    redirect_to I18n.t(:desk_dot_com_url)
  end

  private

end
