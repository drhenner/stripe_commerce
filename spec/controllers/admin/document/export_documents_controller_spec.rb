require  'spec_helper'

describe Admin::Document::ExportDocumentsController do
  # fixtures :all
  render_views

  before(:each) do
    activate_authlogic

    @user = FactoryGirl.create(:admin_user)
    login_as(@user)
  end
  it "index action should render index template" do
    export_document = FactoryGirl.create(:export_document)
    get :index
    response.should render_template(:index)
  end

end
