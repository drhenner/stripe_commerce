require  'spec_helper'

describe Admin::Config::SubscriptionPlansController do
  # fixtures :all
  render_views

  before(:each) do
    activate_authlogic
    @user = create_admin_user
    login_as(@user)
  end


  it "index action should render index template" do
    subscription_plan = FactoryGirl.create(:subscription_plan)
    get :index
    expect(response).to render_template(:index)
  end

  it "show action should render show template" do
    subscription_plan = FactoryGirl.create(:subscription_plan)
    get :show, :id => subscription_plan.id
    expect(response).to render_template(:show)
  end

  it "new action should render new template" do
    get :new
    expect(response).to render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    subscription_plan = FactoryGirl.build(:subscription_plan)
    SubscriptionPlan.any_instance.stubs(:valid?).returns(false)
    post :create, :subscription_plan => subscription_plan.attributes.reject {|k,v| ['id', 'created_at', 'updated_at'].include?(k)}
    expect(response).to render_template(:new)
  end

  it "create action should redirect when model is valid" do
    subscription_plan = FactoryGirl.build(:subscription_plan)
    SubscriptionPlan.any_instance.stubs(:valid?).returns(true)
    post :create, :subscription_plan => subscription_plan.attributes.reject {|k,v| ['id', 'created_at', 'updated_at'].include?(k)}
    expect(response).to redirect_to(admin_config_subscription_plan_url(assigns[:subscription_plan]))
  end

  it "edit action should render edit template" do
    subscription_plan = FactoryGirl.create(:subscription_plan)
    get :edit, :id => subscription_plan.id
    expect(response).to render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    subscription_plan = FactoryGirl.create(:subscription_plan)
    SubscriptionPlan.any_instance.stubs(:valid?).returns(false)
    put :update, :id => subscription_plan.id, :subscription_plan => subscription_plan.attributes.reject {|k,v| ['id', 'created_at', 'updated_at'].include?(k)}
    expect(response).to render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    subscription_plan = FactoryGirl.create(:subscription_plan)
    SubscriptionPlan.any_instance.stubs(:valid?).returns(true)
    put :update, :id => subscription_plan.id, :subscription_plan => subscription_plan.attributes.reject {|k,v| ['id', 'created_at', 'updated_at'].include?(k)}
    expect(response).to redirect_to(admin_config_subscription_plan_url(assigns[:subscription_plan]))
  end

end
