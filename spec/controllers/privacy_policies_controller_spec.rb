require  'spec_helper'

describe PrivacyPoliciesController do
  # fixtures :all
  render_views

  it "show action should render show template" do
    http_login
    get :show
    expect(response).to render_template(:show)
  end
end
