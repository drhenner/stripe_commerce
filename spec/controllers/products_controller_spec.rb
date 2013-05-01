require File.dirname(__FILE__) + '/../spec_helper'

describe ProductsController do

  before(:each) do
    @product = create(:product)
    @variant = create(:variant, :product => @product)
    @variant.stubs(:primary_property).returns(nil)
    @variant.stubs(:properties).returns(nil)
    @product.activate!
    stub_redirect_to_welcome
  end

  it "index action should render index template" do
    get :index
    #response.should render_template(:index)
    response.should redirect_to( preorders_url)
  end

  it "show action should not blow up without a property association" do
    get :show, :id => @product.permalink
    #response.should render_template(:show)
    response.should redirect_to( preorders_url)
  end
end
