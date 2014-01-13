# == USERS DOCUMENTATION
#
# The users table represents...  USERS!!!
#
# When a user signs up to the application they can be put into several states and have
# different requirements depending on how they signed up.
#

##

# == Schema Information
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  first_name        :string(255)
#  last_name         :string(255)
#  birth_date        :date
#  email             :string(255)
#  state             :string(255)
#  account_id        :integer(4)
#  customer_cim_id   :string(255)
#  password_salt     :string(255)
#  crypted_password  :string(255)
#  perishable_token  :string(255)
#  persistence_token :string(255)
#  access_token      :string(255)
#  comments_count    :integer(4)      default(0)
#  created_at        :datetime
#  updated_at        :datetime
#

class User < ActiveRecord::Base
  include TransactionAccountable

  acts_as_authentic do |config|
    config.validate_email_field
    config.validates_length_of_password_field_options( :minimum => 6, :on => :update, :if => :password_changed? )

    # So that Authlogic will not use the LOWER() function when checking login, allowing for benefit of column index.
    config.validates_uniqueness_of_login_field_options :case_sensitive => true
    config.validates_uniqueness_of_email_field_options :case_sensitive => true

    config.validate_login_field = true;
    config.validate_email_field = true;

    # Remove unecessary field validation given by Authlogic.
    #config.validate_password_field = false;

  end

  before_validation :sanitize_data, :before_validation_on_create
  before_create :start_store_credits
  after_create  :subscribe_to_newsletters


  attr_accessor :name_required

  belongs_to :account

  has_many    :users_newsletters
  has_many    :newsletters, :through => :users_newsletters

  has_one     :store_credit
  has_many    :orders
  has_many    :comments
  has_many    :customer_service_comments, :as         => :commentable,
                                          :class_name => 'Comment'
  has_many    :shipments, :through => :orders

  has_many    :viewable_orders,           -> { where({:orders => { :state => ['complete', 'paid', 'preordered', 'canceled']}}) },
                                          :class_name => 'Order'

  has_many    :finished_orders,           -> { where({:orders => { :state => ['complete', 'paid', 'preordered']}}) },
                                          :class_name => 'Order'
  has_many    :completed_orders,          -> { where({:orders => { :state => 'complete'}}) },
                                          :class_name => 'Order'
  has_many    :phones,                    :dependent => :destroy,
                                          :as => :phoneable

  has_one     :primary_phone,             -> { where({:phones => { :primary => true}}) },
                                          :as => :phoneable,
                                          :class_name => 'Phone'

  has_many    :addresses,                 :dependent => :destroy,
                                          :as => :addressable

  has_one     :default_billing_address,   -> { where({addresses: { billing_default: true, active: true}}) },
                                          :as => :addressable,
                                          :class_name => 'Address'

  has_many    :billing_addresses,         -> { where({addresses: { active: true}}) },
                                          :as => :addressable,
                                          :class_name => 'Address'

  has_one     :default_shipping_address,  -> { where({addresses: { default: true, active: true}}) },
                                          :as => :addressable,
                                          :class_name => 'Address'

  has_many     :shipping_addresses,       -> { where({:addresses => { active: true }}) } ,
                                          :as => :addressable,
                                          :class_name => 'Address'

  has_many    :user_roles,                :dependent => :destroy
  has_many    :roles,                     :through => :user_roles

  has_many    :carts,                     :dependent => :destroy
  has_many    :subscriptions

  has_many    :cart_items
  has_many    :shopping_cart_items,       -> { where({:cart_items => { :active        => true,
                                                      :item_type_id  => ItemType::SHOPPING_CART_ID}}) },
                                          :class_name => 'CartItem'

  has_many    :wish_list_items,           -> { where({:cart_items => { :active        => true,
                                                                       :item_type_id  => ItemType::WISH_LIST_ID}}) },
                                          :class_name => 'CartItem'

  has_many    :saved_cart_items,          -> { where({:cart_items => { :active        => true,
                                                                       :item_type_id  => ItemType::SAVE_FOR_LATER}}) },
                                          :class_name => 'CartItem'

  has_many    :purchased_items,           -> { where({:cart_items => { :active        => true,
                                                                       :item_type_id  => ItemType::PURCHASED_ID}}) },
                                          :class_name => 'CartItem'

  has_many    :deleted_cart_items,        -> { where({cart_items: { active: false }}) }, :class_name => 'CartItem'
  has_many    :payment_profiles
  has_many    :active_payment_profiles,   -> { where({ payment_profiles: { active: true }}) }, class_name: 'PaymentProfile'
  has_many    :transaction_ledgers, :as => :accountable

  has_many    :return_authorizations
  has_many    :authored_return_authorizations, :class_name => 'ReturnAuthorization', :foreign_key => 'author_id'


  validates :first_name,  :presence => true, :if => :name_required?,
                          :format   => { :with => CustomValidators::Names.name_validator },
                          :length => { :maximum => 30 }
  validates :last_name,   :presence => true, :if => :name_required?,
                          :format   => { :with => CustomValidators::Names.name_validator },
                          :length   => { :maximum => 35 }
  validates :email,       :presence => true,
                          :uniqueness => true,##  This should be done at the DB this is too expensive in rails
                          :format   => { :with => CustomValidators::Emails.email_validator },
                          :length => { :maximum => 255 }
  validate :validate_age

  validates :password,    :format => { :with => /\A(?=.*\d)(?=.*[a-zA-Z]).{6,25}\z/,
                                       :message  => 'must be 6 characters and contain at least one digit and character'},
                          :if       => :needs_password?

  accepts_nested_attributes_for :addresses, :user_roles
  accepts_nested_attributes_for :phones, :reject_if => lambda { |t| ( t['display_number'].gsub(/\D+/, '').blank?) }
  accepts_nested_attributes_for :customer_service_comments, :reject_if => proc { |attributes| attributes['note'].strip.blank? }

  state_machine :state, :initial => :signed_up do
    state :inactive
    state :active
    state :unregistered
    state :registered
    state :registered_with_credit
    state :signed_up
    state :canceled

    event :activate do
      transition all => :active, :unless => :active?
    end

    event :register do
      transition :from => :active,                 :to => :registered
      transition :from => :inactive,               :to => :registered
      transition :from => :unregistered,           :to => :registered
      transition :from => :registered_with_credit, :to => :registered
      transition :from => :signed_up,              :to => :registered
      transition :from => :canceled,               :to => :registered
    end

    event :cancel do
      transition :from => [:inactive, :active, :unregistered, :registered, :registered_with_credit, :canceled], :to => :canceled
    end

  end

  # returns true or false if the user is active or not
  #
  # @param [none]
  # @return [ Boolean ]
  def active?
    !['canceled', 'inactive', 'signed_up'].any? {|s| self.state == s }
  end

  # in plain english returns 'true' or 'false' if the user is active or not
  #
  # @param [none]
  # @return [ String ]
  def display_active
    active?.to_s
  end

  # returns true or false if the user has a role or not
  #
  # @param [String] role name the user should have
  # @return [ Boolean ]
  def role?(role_name)
    roles.any? {|r| r.name == role_name.to_s}
  end

  # returns true or false if the user is an admin or not
  #
  # @param [none]
  # @return [ Boolean ]
  def admin?
    has_admin_role = Rails.cache.fetch("ROLE-ADMIN?-#{cached_role_ids.join('-')}", :expires_in => 12.hours) do
      role?(:administrator) || role?(:super_administrator)
    end
    has_admin_role || super_admin?
  end

  # returns true or false if the user is a super admin or not
  # FYI your IT staff might be an admin but your CTO and IT director is a super admin
  #
  # @param [none]
  # @return [ Boolean ]
  def super_admin?
    Rails.cache.fetch("SUPER_ADMIN?-#{cached_role_ids.join('-')}", :expires_in => 12.hours) do
      role?(:super_administrator)
    end
  end

  def csrep?
    Rails.cache.fetch("csrep?-#{cached_role_ids.join('-')}", :expires_in => 12.hours) do
      role?(:customer_service)
    end
  end

  # returns your last cart or nil
  #
  # @param [none]
  # @return [ Cart ]
  def current_cart
    carts.last
  end

  # formats the String
  #
  # @param [String] formatted in Euro-time
  # @return [ none ]  sets birth_date for the user
  def format_birth_date(b_date)
    self.birth_date = Date.strptime(b_date, "%m/%d/%Y").to_s(:db) if b_date.present?
  end

  def display_birth_date
    birth_date ? I18n.localize(birth_date, :format => :us_time) : 'N/A'
  end

  # formats the String
  #
  # @param [String] formatted in Euro-time
  # @return [ none ]  sets birth_date for the user
  def form_birth_date
    birth_date.present? ? birth_date.strftime("%m/%d/%Y") : nil
  end
  # formats the String
  #
  # @param [String] formatted in Euro-time
  # @return [ none ]  sets birth_date for the user
  def form_birth_date=(val)
    self.birth_date = Date.strptime(val, "%m/%d/%Y").to_s(:db) if val.present?
  end

  ##  This method will one day grow into the products a user most likely likes.
  #   Storing a list of product ids vs cron each night might be the most efficent mode for this method to work.
  def might_be_interested_in_these_products
    Product.limit(4).all
  end

  # Returns the default billing address if it exists.   otherwise returns the shipping address
  #
  # @param [none]
  # @return [ Address ]
  def billing_address
    default_billing_address ? default_billing_address : shipping_address
  end

  # Returns the default shipping address if it exists.   otherwise returns the first shipping address
  #
  # @param [none]
  # @return [ Address ]
  def shipping_address
    default_shipping_address ? default_shipping_address : shipping_addresses.first
  end

  # returns true or false if the user is a registered user or not
  #
  # @param [none]
  # @return [ Boolean ]
  def registered_user?
    registered? || registered_with_credit?
  end

  # gives the user's first and last name if available, otherwise returns the users email
  #
  # @param [none]
  # @return [ String ]
  def name
    (first_name? && last_name?) ? [first_name.capitalize, last_name.capitalize ].join(" ") : email
  end

  # sanitizes the saving of data.  removes white space and assigns a free account type if one doesn't exist
  #
  # @param  [ none ]
  # @return [ none ]
  def sanitize_data
    self.email      = self.email.strip.downcase       unless email.blank?
    self.first_name = self.first_name.strip.capitalize  unless first_name.nil?
    self.last_name  = self.last_name.strip.capitalize   unless last_name.nil?

    ## CHANGE THIS IF YOU HAVE DIFFERENT ACCOUNT TYPES
    unless account_id
      self.account = Account.first
    end
  end

  # email activation instructions after a user signs up
  #
  # @param  [ none ]
  # @return [ none ]
  def deliver_activation_instructions!
    #Notifier.signup_notification(self).deliver
    Resque.enqueue(Jobs::SendSignUpNotification, self.id)
  end

  # name and email string for the user
  # ex. '"John Wayne" "jwayne@badboy.com"'
  #
  # @param  [ none ]
  # @return [ String ]
  def email_address_with_name
    "\"#{name}\" <#{email}>"
  end

  # place holder method for creating cim profiles for recurring billing
  #
  # @param  [ none ]
  # @return [ String ] CIM id returned from the gateway
  def get_cim_profile
    return customer_cim_id if customer_cim_id
    create_cim_profile
    customer_cim_id
  end

  # name and first line of address (used by credit card gateway to descript the merchant)
  #
  # @param  [ none ]
  # @return [ String ] name and first line of address
  def merchant_description
    [name, default_shipping_address.try(:address_lines)].compact.join(', ')
  end

  # Find users that have signed up for the subscription
  #
  # @params [ none ]
  # @return [ Arel ]
  def self.find_subscription_users
    where('account_id NOT IN (?)', Account::FREE_ACCOUNT_IDS )
  end

  def self.get_new_user(args)
    # If the user has signed up without a password then they can register
    user = User.where(:email => args[:email]).where(:crypted_password => nil).first
    user.assign_attributes(args) if user
    user || User.new(args)
  end

  # include addresses in Find
  #
  # @params [ none ]
  # @return [ Arel ]
  def include_default_addresses
    includes([:default_billing_address, :default_shipping_address, :account])
  end

  # paginated results from the admin User grid
  #
  # @param [Optional params]
  # @return [ Array[User] ]
  def self.admin_grid(params = {})
    grid = self
    grid = grid.includes(:roles)
    grid = grid.where("users.first_name iLIKE ?", "%#{params[:first_name]}%") if params[:first_name].present?
    grid = grid.where("users.last_name iLIKE ?",  "%#{params[:last_name]}%")  if params[:last_name].present?
    grid = grid.where("users.email iLIKE ?",      "%#{params[:email]}%")      if params[:email].present?
    grid
  end

  def deliver_password_reset_instructions!
    self.reset_perishable_token!
    #Notifier.password_reset_instructions(self).deliver
    Resque.enqueue(Jobs::SendPasswordResetInstructions, self.id)
  end

  def number_of_finished_orders
    finished_orders.count
  end

  def number_of_finished_orders_at(at)
    finished_orders.select{|o| o.completed_at < at }.size
  end

  private

  def needs_password?
    (new_record? || password_changed?) && state != 'signed_up'
  end

  def name_required?
    name_required || registered_user?
  end

  def validate_age
    if birth_date && birth_date_changed?
      if too_old?
        self.errors.add(:birth_date, "This user is too old (#{age}).")
      elsif too_young?
        self.errors.add(:birth_date, "This user is too young (#{age}).")
      end
    end
  end

  def too_old?
    age > 110
  end

  def too_young?
    age < 2
  end

  def age
    birth_date.age
  end

  def start_store_credits
    self.store_credit = StoreCredit.new(:amount => 0.0, :user => self)
  end

  def password_required?
    self.crypted_password.blank?
  end

  #def create_cim_profile
  #  return true if customer_cim_id
  #  #Login to the gateway using your credentials in environment.rb
  #  @gateway = GATEWAY
  #
  #  #setup the user object to save
  #  @user = {:profile => user_profile}
  #
  #  #send the create message to the gateway API
  #  response = @gateway.create_customer_profile(@user)
  #
  #  if response.success? and response.authorization
  #    update_attributes({:customer_cim_id => response.authorization})
  #    return true
  #  end
  #  return false
  #end

  def user_profile
    return {:merchant_customer_id => id, :email => email, :description => merchant_description}
  end

  def before_validation_on_create
    self.access_token = SecureRandom::hex(9+rand(6)) if new_record? and access_token.nil?
  end

  def subscribe_to_newsletters
    newsletters = Newsletter.where(:autosubscribe => true)
    newsletters.each do |newsletter|
      self.newsletters << newsletter
      Resque.enqueue(Jobs::SubscribeUserToMailChimpList, self.id, newsletter.id) if newsletter.mailchimp_list_id
    end
    self.save(:validate => false)
  end

  def cached_role_ids
    Rails.cache.delete("cached_role_ids-#{id}") if Rails.env.test?
    Rails.cache.fetch("cached_role_ids-#{id}", :expires_in => 3.hours) do
      role_ids
    end
  end
end
