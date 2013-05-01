require  'spec_helper'

describe Members::FitnessesController do
  # fixtures :all
  render_views

  before(:each) do
    activate_authlogic
    @cur_user = create(:user)
    login_as(@cur_user)
  end

  it "show action should render show template" do
    get :show
    expect(response).to render_template(:show)
  end
end
