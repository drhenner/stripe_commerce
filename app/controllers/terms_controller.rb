class TermsController < ApplicationController
  skip_before_filter :redirect_to_welcome
  def index
  end
end
