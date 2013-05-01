class Subscription < ActiveRecord::Base
  include TransactionAccountable

  attr_accessible :order_item_id, :stripe_customer_token, :subscription_plan_id, :payment_profile_id, :total_payments, :user_id, :active, :remaining_payments, :shipping_address_id, :billing_address_id
  #, :product_id
  attr_accessible :next_bill_date,
                  :remaining_payments,
                  :shipping_address_id,
                  :payment_profile_id,
                  :billing_address_id, :as => :admin
  belongs_to  :user
  belongs_to  :order_item
  belongs_to  :subscription_plan
  belongs_to  :shipping_address, :class_name => 'Address'
  belongs_to  :billing_address,  :class_name => 'Address'
  belongs_to  :payment_profile

  has_many    :transaction_ledgers, :as => :accountable
  has_many    :batches, :as => :batchable

  before_create :set_remaining_payments
  after_create :set_total_payments

  validates :order_item_id,         :presence => true
  validates :stripe_customer_token, :presence => true, :if => :active?
  validates :next_bill_date,        :presence => true, :if => :active?
  validates :subscription_plan_id,  :presence => true
  validates :user_id,               :presence => true
  #validates :shipping_address_id,               :presence => true
  #:ship_address_id, :ship_address,
  delegate  :variant,:variant_id, :to => :order_item, :allow_nil => false

  def cheapest_shipping_rate()
    ShippingRate.joins(:shipping_method).where(['
                        shipping_methods.shipping_zone_id = ?
                        AND shipping_rates.minimum_charge <= ?', shipping_address.state.shipping_zone_id, variant.price]).order('shipping_rates.rate ASC').first
  end

  def cancel!
    self.remaining_payments = 0
    self.canceled           = true
    self.save
  end

  def is_active?
    active && !canceled
  end

  def purchased!
    self.active = true
    self.next_bill_date ||= (Time.zone.now + 1.month).to_date
    # log in account system as ...
    self.save!
  end

  def completed_billing_cycle!
    self.remaining_payments = remaining_payments - 1
    self.next_bill_date = next_bill_date + 1.month unless self.remaining_payments <= 0
    self.save!
  end

  def total_cost_in_cents # in cents
    (total_cost.to_f / 100.0).round_at(2)
  end

  def total_cost
    (number_of_total_payments * subscription_plan.amount) + total_tax_amount
  end

  def individual_cost
    (subscription_plan.amount) + individual_tax_amount
  end

  def number_of_total_payments
    total_payments ? total_payments : subscription_plan.total_payments
  end

  def total_tax_amount # in cents
    (individual_tax_amount * number_of_total_payments).to_i
  end

  def individual_tax_amount # in cents
    (subscription_plan.amount * order_item.tax_percentage / 100.0).to_i
  end

  def subscription_plan_name
    Rails.cache.fetch("subscription_plan_name-#{subscription_plan_id}", :expires_in => 3.hours) do
      subscription_plan.name
    end
  end

  def self.with_email(email)
    if email.present?
      where("users.email = ?", email )
    else
      scoped
    end
  end

  def self.active
    where(:subscriptions => {:active => true})
  end

  def self.not_canceled
    where(:subscriptions => {:canceled => false})
  end

  def self.has_remaining_payments
    where("subscriptions.remaining_payments > 0")
  end

  def self.needs_to_be_billed
    active.not_canceled.has_remaining_payments.where('subscriptions.next_bill_date <= ?', Time.zone.now.to_date)
  end
  private

  def set_remaining_payments
    self.remaining_payments = self.total_payments || subscription_plan.total_payments
  end

  def set_total_payments
    self.total_payments ||= subscription_plan.total_payments
  end
end
