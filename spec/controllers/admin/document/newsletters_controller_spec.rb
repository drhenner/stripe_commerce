require  'spec_helper'

describe Admin::Document::NewslettersController do
  # fixtures :all
  render_views
  before(:each) do
    activate_authlogic
    @user = create_admin_user
    login_as(@user)
  end

  it "index action should render index template" do
    newsletter = FactoryGirl.create(:newsletter)
    get :index
    expect(response).to render_template(:index)
  end

  it "show action should render show template" do
    newsletter = FactoryGirl.create(:newsletter)
    get :show, :id => newsletter.id
    expect(response).to render_template(:show)
  end

  it "new action should render new template" do
    get :new
    expect(response).to render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    newsletter = FactoryGirl.build(:newsletter)
    Newsletter.any_instance.stubs(:valid?).returns(false)
    post :create, :newsletter => newsletter.attributes.reject {|k,v| ['id'].include?(k)}
    expect(response).to render_template(:new)
  end

  it "create action should redirect when model is valid" do
    newsletter = FactoryGirl.build(:newsletter)
    Newsletter.any_instance.stubs(:valid?).returns(true)
    post :create, :newsletter => newsletter.attributes.reject {|k,v| ['id'].include?(k)}
    expect(response).to redirect_to(admin_document_newsletter_url(assigns[:newsletter]))
  end

  it "edit action should render edit template" do
    newsletter = FactoryGirl.create(:newsletter)
    get :edit, :id => newsletter.id
    expect(response).to render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    newsletter = FactoryGirl.create(:newsletter)
    Newsletter.any_instance.stubs(:valid?).returns(false)
    put :update, :id => newsletter.id, :newsletter => newsletter.attributes.reject {|k,v| ['id'].include?(k)}
    expect(response).to render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    newsletter = FactoryGirl.create(:newsletter)
    Newsletter.any_instance.stubs(:valid?).returns(true)
    put :update, :id => newsletter.id, :newsletter => newsletter.attributes.reject {|k,v| ['id'].include?(k)}
    expect(response).to redirect_to(admin_document_newsletter_url(assigns[:newsletter]))
  end

  it "destroy action should destroy model and redirect to index action" do
    newsletter = FactoryGirl.create(:newsletter)
    delete :destroy, :id => newsletter.id
    expect(response).to redirect_to(admin_document_newsletters_url)
    Newsletter.exists?(newsletter.id).should be_false
  end
end
