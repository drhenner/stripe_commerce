require  'spec_helper'

describe Myaccount::CreditCardsController do
  render_views

  before(:each) do
    activate_authlogic
    @user = create(:user)
    login_as(@user)
    stub_redirect_to_welcome

    charge_mock = mock()
    charge_mock.stubs(:customer_token).returns('fakeTOKEN')

    Stripe::Charge.stubs(:create).returns(charge_mock)

  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    PaymentProfile.any_instance.stubs(:valid?).returns(false)
    PaymentProfile.any_instance.stubs(:save_stripe_customer).returns(true)
    credit_card = build(:payment_profile)
    post :create, :payment_profile => credit_card.attributes#.merge(:credit_card_info)
  end

  it "destroy action should inactivate model and redirect to index action" do
    PaymentProfile.any_instance.stubs(:save_stripe_customer).returns(true)
    @credit_card = create(:payment_profile, :user => @user)
    delete :destroy, :id => @credit_card.id
    response.should redirect_to(myaccount_credit_cards_url)
    PaymentProfile.exists?(@credit_card.id).should be_true

    c = PaymentProfile.find(@credit_card.id)
    c.active.should be_false
  end
end

describe Myaccount::CreditCardsController do
  render_views

  it "index action should go to login page" do
    stub_redirect_to_welcome
    get :index
    response.should redirect_to(login_url)
  end

  it "show action should go to login page" do

    #charge_mock = mock()
    #charge_mock.stubs(:customer_token).returns('fakeTOKEN')
    #Stripe::Charge.stubs(:create).returns(charge_mock)
    PaymentProfile.any_instance.stubs(:save_stripe_customer).returns(true)

    stub_redirect_to_welcome
    @credit_card = create(:payment_profile)
    get :index
    response.should redirect_to(login_url)
  end
end
