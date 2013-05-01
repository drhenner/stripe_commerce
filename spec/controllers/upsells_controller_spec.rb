require  'spec_helper'

describe UpsellsController do
  # fixtures :all
  render_views

  before do
    stub_redirect_to_welcome
    @cart      = FactoryGirl.create(:cart)
    @cart_item = FactoryGirl.create(:cart_item, :cart => @cart)
    @controller.stubs(:session_cart).returns(@cart)
  end

  it "update action should redirect when model is valid" do
    variant = FactoryGirl.create(:variant)
    put :update, :id => variant.id
    expect(response).to redirect_to(preorders_url(:anchor => 'order-summary'))
    @controller.session_cart.shopping_cart_items.size.should eq 2
  end

  it "destroy action should destroy model and redirect to index action" do
    delete :destroy, :id => @cart_item.id
    expect(response).to redirect_to(preorders_url(:anchor => 'order-summary'))
    CartItem.find(@cart_item.id).active.should be_false
  end
end
