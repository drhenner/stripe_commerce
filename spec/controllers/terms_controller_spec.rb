require  'spec_helper'

describe TermsController do
  render_views

  it "index action should render index template" do
    stub_redirect_to_welcome
    get :index
    #response.should render_template(:index)
    expect(response).to render_template(:index)
  end
end
