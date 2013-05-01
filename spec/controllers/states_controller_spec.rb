require 'spec_helper'

describe StatesController do

  it "index action should render index template" do
    stub_redirect_to_welcome
    request.env["HTTP_ACCEPT"] = "application/json"
    get :index, :country_id => 2
    assert_response :success
  end
end
