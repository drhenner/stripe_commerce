require  'spec_helper'

describe AboutsController do
  render_views

  before do
    stub_redirect_to_welcome
  end

  it "show action should render show template" do
    get :show
    expect(response).to render_template(:text => '')
  end
end
