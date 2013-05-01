require  'spec_helper'

describe Admin::SignupsController do
  # fixtures :all
  render_views
  before(:each) do
    activate_authlogic
    @user = create_admin_user
    login_as(@user)
  end

  it "index action should render index template" do
    signup = FactoryGirl.create(:signup)
    get :index
    expect(response).to render_template(:index)
  end

  it "show action should render show template" do
    signup = FactoryGirl.create(:signup)
    get :show, :id => signup.id
    expect(response).to render_template(:show)
  end

  it "new action should render new template" do
    get :new
    expect(response).to render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    signup = FactoryGirl.build(:signup)
    Signup.any_instance.stubs(:valid?).returns(false)
    post :create, :signup => signup.attributes.reject {|k,v| ['id', 'created_at', 'updated_at'].include?(k)}
    expect(response).to render_template(:new)
  end

  it "create action should redirect when model is valid" do
    signup = FactoryGirl.build(:signup)
    Signup.any_instance.stubs(:valid?).returns(true)
    post :create, :signup => signup.attributes.reject {|k,v| ['id', 'created_at', 'updated_at'].include?(k)}
    expect(response).to redirect_to(admin_signup_url(assigns[:signup]))
  end

  it "edit action should render edit template" do
    signup = FactoryGirl.create(:signup)
    get :edit, :id => signup.id
    expect(response).to render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    signup = FactoryGirl.create(:signup)
    Signup.any_instance.stubs(:valid?).returns(false)
    put :update, :id => signup.id, :signup => signup.attributes.reject {|k,v| ['id', 'created_at', 'updated_at'].include?(k)}
    expect(response).to render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    signup = FactoryGirl.create(:signup)
    Signup.any_instance.stubs(:valid?).returns(true)
    put :update, :id => signup.id, :signup => signup.attributes.reject {|k,v| ['id', 'created_at', 'updated_at'].include?(k)}
    expect(response).to redirect_to(admin_signup_url(assigns[:signup]))
  end

  it "destroy action should destroy model and redirect to index action" do
    signup = FactoryGirl.create(:signup)
    delete :destroy, :id => signup.id
    expect(response).to redirect_to(admin_signups_url)
    Signup.exists?(signup.id).should be_false
  end
end
