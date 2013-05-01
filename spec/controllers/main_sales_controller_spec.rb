require  'spec_helper'

describe MainSalesController do
  # fixtures :all
  render_views

  it "update action should redirect when model is valid" do
    stub_redirect_to_welcome
    main_sale = FactoryGirl.create(:variant)
    cart = FactoryGirl.create(:cart)
    @controller.stubs(:session_cart).returns(cart)
    put :update, :variant_id => main_sale.id
    expect(response).to redirect_to(preorders_url(:anchor => 'order-summary'))
    cart.reload
    expect(cart.shopping_cart_items.map(&:variant_id).include?(main_sale.id)).to be_true
  end
end
