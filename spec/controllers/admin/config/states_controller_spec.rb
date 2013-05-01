require  'spec_helper'

describe Admin::Config::StatesController do
  # fixtures :all
  render_views

  before(:each) do
    activate_authlogic
    @user = create_admin_user
    login_as(@user)
  end

  it "index action should render index template" do
    get :index
    expect(response).to render_template(:index)
  end

  it "show action should render show template" do
    state = State.first
    get :show, :id => state.id
    expect(response).to render_template(:show)
  end

  it "new action should render new template" do
    get :new
    expect(response).to render_template(:new)
  end

  it "update action should redirect when model is valid" do
    state = State.first
    State.any_instance.stubs(:valid?).returns(true)
    put :update, :id => state.id, :state => state.attributes.reject {|k,v| ['id'].include?(k)}
    State.find(state.id).active.should be_true
    expect(response).to redirect_to(admin_config_states_url())
  end

  it "destroy action should destroy model and redirect to index action" do
    state = State.first
    delete :destroy, :id => state.id
    expect(response).to redirect_to(admin_config_states_url)
    State.find(state.id).active.should be_false
  end
end
