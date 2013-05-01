require 'spec_helper'

describe "admin/rma/return_authorizations/show.html.erb" do
  before(:each) do
    @order = create(:order)
    ReturnAuthorization.any_instance.stubs(:max_refund).returns(10000)
    @return_authorization = build(:return_authorization)
    @return_authorization.save
  end

  it "renders attributes in <p>" do
    render :template => "admin/rma/return_authorizations/show", :handlers => [:erb]
  end
end
