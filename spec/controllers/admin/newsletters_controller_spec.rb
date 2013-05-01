require  'spec_helper'

describe Admin::NewslettersController do
  # fixtures :all
  render_views
  before(:each) do
    activate_authlogic
    @user = create_admin_user
    login_as(@user)
  end

  it "index action should render index template" do
    user = FactoryGirl.create(:user)
    get :index, :user_id => user.id
    expect(response).to render_template(:index)
  end

  it "show action should render show template" do
    user = FactoryGirl.create(:user)
    newsletter = Newsletter.first || FactoryGirl.create(:newsletter)
    get :show, :user_id => user.id, :id => newsletter.id
    expect(response).to render_template(:show)
  end

  it "edit action should render edit template" do
    user = FactoryGirl.create(:user)
    get :edit, :user_id => user.id, :id => 'preferences'
    expect(response).to render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    user = FactoryGirl.create(:user)
    newsletter = Newsletter.first || FactoryGirl.create(:newsletter)
    User.any_instance.stubs(:valid?).returns(false)
    put :update, :user_id => user.id, :id => newsletter.id, :user => {:newsletter_ids => [newsletter.id]}
    expect(response).to render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    user = FactoryGirl.create(:user)
    newsletter = Newsletter.first || FactoryGirl.create(:newsletter)
    User.any_instance.stubs(:valid?).returns(true)
    put :update, :user_id => user.id, :id => newsletter.id, :user => {:newsletter_ids => [newsletter.id]}
    expect(response).to redirect_to(admin_user_newsletters_url(user))
  end

  it "destroy action should destroy model and redirect to index action" do
    user = FactoryGirl.create(:user)
    users_newsletter = FactoryGirl.create(:users_newsletter, :user_id => user.id)
    delete :destroy, :user_id => user, :id => users_newsletter.id
    expect(response).to redirect_to(admin_user_newsletters_url(user))
    UsersNewsletter.exists?(users_newsletter.id).should be_false
  end
end
