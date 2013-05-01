require  'spec_helper'

describe Admin::Fulfillment::OrdersController do
  render_views

  before(:each) do
    @order = create(:order)
    activate_authlogic
    @user = create_admin_user
    login_as(@user)
  end

  it "edit action should render edit template" do
    @order = create(:order)
    get :edit, :id => @order.id, :order_id => @order.number
    response.should render_template(:edit)
  end

end
