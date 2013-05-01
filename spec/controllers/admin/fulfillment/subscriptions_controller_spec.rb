require  'spec_helper'

describe Admin::Fulfillment::SubscriptionsController do
  # fixtures :all
  render_views

  before(:each) do
    @order = create(:order)
    activate_authlogic
    @user = create_admin_user
    login_as(@user)
  end

  it "index action should render index template" do
    subscription = FactoryGirl.create(:subscription)
    get :index
    expect(response).to render_template(:index)
  end

  it "show action should render show template" do
    subscription = FactoryGirl.create(:subscription)
    get :show, :id => subscription.id
    expect(response).to render_template(:show)
  end

  it "edit action should render edit template" do
    subscription = FactoryGirl.create(:subscription)
    get :edit, :id => subscription.id
    expect(response).to render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    subscription = FactoryGirl.create(:subscription)
    Subscription.any_instance.stubs(:valid?).returns(false)
    put :update, :id => subscription.id, :subscription => subscription.attributes.reject {|k,v| ['id', 'created_at', 'updated_at', 'next_bill_date', 'failed_attempts', 'canceled', 'subscription_plan_id', 'user_id', 'order_item_id', 'stripe_customer_token', 'total_payments', 'active'].include?(k)}
    expect(response).to render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    subscription = FactoryGirl.create(:subscription)
    Subscription.any_instance.stubs(:valid?).returns(true)
    put :update, :id => subscription.id, :subscription => subscription.attributes.reject {|k,v| ['id', 'created_at', 'updated_at', 'next_bill_date', 'failed_attempts', 'canceled', 'subscription_plan_id', 'user_id', 'order_item_id', 'stripe_customer_token', 'total_payments', 'active'].include?(k)}
    expect(response).to redirect_to(admin_fulfillment_subscription_url(assigns[:subscription]))
  end

  it "destroy action should destroy model and redirect to index action" do
    subscription = FactoryGirl.create(:subscription)
    delete :destroy, :id => subscription.id
    expect(response).to redirect_to(admin_fulfillment_subscription_url(subscription))
    Subscription.find(subscription.id).active.should be_false
  end
end
