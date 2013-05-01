class Members::BaseController < ApplicationController
  skip_before_filter :redirect_to_welcome
  layout 'raw'
end
