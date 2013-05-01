require  'spec_helper'

describe Myaccount::OrdersController do
  render_views

  before(:each) do
    activate_authlogic

    @user = create(:user)
    login_as(@user)
    stub_redirect_to_welcome
  end

  it "index action should render index template" do
    @order = create(:order, :user => @user)
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    Stripe::Customer.stubs(:create).returns({'id' => 'testTOKEN'})
    Stripe::Customer.stubs(:retrieve).returns(stripe_retrieve_response)
    payment_profile = FactoryGirl.create(:payment_profile)
    @order = build(:order, :user => @user )
    @order.state = 'complete'
    @order.save
    Order.any_instance.stubs(:payment_profile).returns(payment_profile)
    get :show, :id => @order.number
    response.should render_template(:show)
  end

end

describe Myaccount::OrdersController do
  render_views

  it "index action should go to login page" do
    stub_redirect_to_welcome
    get :index
    response.should redirect_to(login_url)
  end

  it "show action should go to login page" do
    stub_redirect_to_welcome
    @order = create(:order)
    @order.state = 'complete'
    @order.save
    get :show, :id => @order.id
    response.should redirect_to(login_url)
  end
end
