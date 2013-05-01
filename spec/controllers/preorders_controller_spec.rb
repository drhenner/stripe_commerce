require  'spec_helper'

describe PreordersController do
  # fixtures :all
  render_views

  before do
    http_login
  end

  it "index action should render index template" do
    Product.stubs(:preorders)
    p = create(:product)
    p.activate!
    Settings.stubs(:allow_preorders).returns(true)
    cart = create(:cart)
    cart_item = create(:cart_item)
    cart.stubs(:media_cart_items).returns([cart_item])
    @controller.stubs(:session_cart).returns(cart)
    get :index
    expect(response).to render_template(:index)
  end

  it "index action should render index template" do
    Product.stubs(:preorders)
    p = create(:product)
    p.activate!
    Settings.stubs(:allow_preorders).returns(true)
    cart = create(:cart)
    cart_item = create(:cart_item)
    cart.stubs(:shopping_cart_items).returns([])
    @controller.stubs(:session_cart).returns(cart)
    get :index
    expect(response).to redirect_to(root_url)
  end

  it "index action should render index template" do
    Settings.stubs(:allow_preorders).returns(false)
    get :index
    expect(response).to redirect_to(root_url)
  end

  it "create action should add the default item to the cart" do
    stub_redirect_to_welcome
    Cart.any_instance.stubs(:add_default_presale_sale)
    post :create
    expect(response).to redirect_to(preorders_url)
  end
  it "show action should redirect" do
    stub_redirect_to_welcome
#    preorder = FactoryGirl.create(:product)
    get :show, :id => 'preorder'
    expect(response).to redirect_to(preorders_url)
  end
end
