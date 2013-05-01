module Hadean
  module TestHelpers
    include AuthHelper

    def create_admin_user(args = {})
      @uusseerr = FactoryGirl.create(:user, args)
      #@uusseerr.stubs(:super_admin?).returns(false)
      roles_mock = mock()
      roles_mock.stubs(:name).returns(Role::ADMIN)
      @uusseerr.stubs(:cached_role_ids).returns([Role::ADMIN_ID])
      @uusseerr.stubs(:roles).returns([roles_mock])
      @uusseerr
    end

    def create_real_admin_user(args = {})
      @uusseerr = FactoryGirl.create(:user, args)
      @uusseerr.role_ids = [Role.find_by_name(Role::ADMIN).id]
      @uusseerr.save
      @uusseerr
    end
    def create_super_admin_user(args = {})
      @uusseerr = FactoryGirl.create(:user, args)
      roles_mock = mock()
      roles_mock.stubs(:name).returns(Role::SUPER_ADMIN)
      @uusseerr.stubs(:cached_role_ids).returns([Role::SUPER_ADMIN_ID])
      @uusseerr.stubs(:roles).returns([roles_mock])
      @uusseerr
    end

    def login_as(user)
      http_login
      user_session_for user
      controller.stubs(:current_user).returns(user)
    end

    def stub_redirect_to_welcome
      http_login
      @controller.stubs(:redirect_to_welcome)
    end

    def user_session_for(user)
      UserSession.create(user)
    end

    #def current_user
    #  UserSession.find.user
    #end

    def set_current_user(user = create(:user))
      UserSession.create(user)
      controller.stubs(:current_user).returns(user)
    end

    def create_cart(customer, admin_user = nil, variants = [])
      user = admin_user || customer
      test_cart = Cart.create(:user_id => user.id, :customer_id => customer.id)

      variants.each do |variant|
        test_cart.add_variant(variant.id, customer)
      end

      @controller.stubs(:session_cart).returns(test_cart)
    end
    #def admin_role
    #  role_by_name Role::ADMIN
    #end
    #
    #def role_by_name name
    #  Role.find_by_name name
    #end
  end
end
