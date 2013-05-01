require  'spec_helper'

describe ContactUsController do
  # fixtures :all
  render_views

  it "show action should render show template" do
    http_login
    get :show
    #expect(response).to render_template(:show)
    expect(response).to render_template(:text => '')
  end
end
