# == Class Info
#
#  Every monetary charge creates an invoice.  Thus when you charge a customer XYZ,
#  you are actually using an invoice for the charge and not the order.  This allows
#  flexibility within accounting and returns and even some new charge that will be made
#  in the future.  If the system was only doing Cash-Based account the Invoices table
#  would be the only table needed.  NOTE: DO NOT THINK FOR A SECOND CASH BASED ACCOUNT IS GOOD ENOUGH!


# == Schema Information
#
# Table name: invoices
#
#  id              :integer(4)      not null, primary key
#  order_id        :integer(4)      not null
#  amount          :decimal(8, 2)   not null
#  invoice_type    :string(255)     default("Purchase"), not null
#  state           :string(255)     not null
#  active          :boolean(1)      default(TRUE), not null
#  created_at      :datetime
#  updated_at      :datetime
#  credited_amount :decimal(8, 2)   default(0.0)
#  card_token       character varying(100),
#  tax_amount       integer,
#  tax_state_id     integer,
#  charge_token     character varying(100),
#  customer_token   character varying(100),
#

class Invoice < ActiveRecord::Base

  has_many :payments
  has_many :batches, :as => :batchable#, :polymorphic => true
  belongs_to :order


  validates :amount,        :presence => true
  validates :invoice_type,  :presence => true
  #validates :order_id,      :presence => true

  PURCHASE  = 'Purchase'
  PREPURCHASE = 'Pre-Purchase'
  RMA       = 'RMA'

  INVOICE_TYPES = [PURCHASE, RMA]
  NUMBER_SEED     = 3002001004005
  CHARACTERS_SEED = 20
  #cattr_accessor :gateway

  # after_create :create_authorized_transaction

  #def create_authorized_transaction
  #
  #end
  state_machine :initial => :pending do
    state :pending
    state :authorized
    state :preordered
    state :paid
    state :payment_declined
    state :canceled

    #after_transition :on => 'return_money_and_cancel', :do => [:return_money]
    after_transition :to => :canceled, :do => [:return_money]

    event :payment_rma do
      transition :from => :pending,
                  :to   => :refunded
    end
    event :preorder do
      transition :from => :pending,
                 :to   => :preordered
    end
    event :payment_authorized do
      transition :from => :pending,
                  :to   => :authorized
      transition :from => :payment_declined,
                  :to   => :authorized
    end
    event :payment_captured do
      transition :from => :authorized,
                  :to   => :paid
      transition :from => :preordered,
                  :to   => :paid
    end
    event :payment_charge do
      transition :from => :payment_declined,
                  :to   => :paid
      transition :from => :pending,
                  :to   => :paid
      transition :from => :preordered, :to   => :paid
    end
    event :transaction_declined do
      transition :from => :pending,
                  :to   => :payment_declined
      transition :from => :payment_declined,
                  :to   => :payment_declined
      transition :from => :preordered,
                  :to   => :payment_declined
      transition :from => :authorized,
                  :to   => :payment_declined
    end

    event :cancel do
      transition :from => :paid,
                  :to  => :canceled

    end
    event :return_money_and_cancel do
      #transition :from => :paid, :to  => :canceled
      transition :from => :authorized, :to  => :canceled
      transition :from => :preordered, :to  => :canceled
    end
  end

  #  the full shipping address as an array compacted.
  #
  # @param [none]
  # @return [Array]  has ("name", "address1", "address2"(unless nil), "city state zip") or nil
  def order_ship_address_lines
    order.ship_address.try(:full_address_array)
  end

  #  the full order address as an array compacted.
  #
  # @param [none]
  # @return [Array]  has ("name", "address1", "address2"(unless nil), "city state zip") or nil
  def order_billing_address_lines
    order.bill_address.try(:full_address_array)
  end

  # date the invoice was created (not the date it was paid)
  #
  # @param [Optional Symbol] date format to be returned
  # @return [String] formated date
  def invoice_date(format = :us_date)
    I18n.localize(created_at, :format => format)
  end

  # invoice number
  #
  # @param [none]
  # @return [String] invoice number calculated based off the id and preset values
  def number
    (NUMBER_SEED + id).to_s(CHARACTERS_SEED)
  end

  # invoice id calculated from the id of the number
  #
  # @param [none]
  # @return [Integer] invoice id calculated based off the id and preset values
  def self.id_from_number(num)
    num.to_i(CHARACTERS_SEED) - NUMBER_SEED
  end

  # find invoice based off the invoice's number
  #
  # @param [String] invoice Number
  # @return [Invoice] invoice
  def self.find_by_number(num)
    find(id_from_number(num))##  now we can search by id which should be much faster
  end

  # make an invoice object (not saved)
  #
  # @param [Integer] order id
  # @param [Decimal] amount in dollars
  # @return [Invoice] invoice object
  def Invoice.generate(order_id, charge_amount, payment_method, taxed_amount = 0.0, credited_amount = 0.0)
    #amount = (charge_amount.to_f / 100.0).round_at(2)
    invoice = Invoice.new(:order_id       => order_id,
                :amount         => charge_amount,
                :invoice_type   => PURCHASE,
                :tax_amount     => (taxed_amount * 100.0).to_i,
                :credited_amount => credited_amount,
                :customer_token => payment_method.customer_token)
    invoice
  end

  def Invoice.generate_preorder(order_id, charge_amount, payment_method, taxed_amount, credited_amount)
    invoice = Invoice.new(:order_id       => order_id,
                :amount         => charge_amount,
                :invoice_type   => PREPURCHASE,
                :tax_amount     => (taxed_amount * 100.0).to_i,
                :credited_amount => credited_amount,
                :customer_token => payment_method.customer_token)
    invoice
  end

  def log_preorder_stripe_customer_payment(customer_token, options = {})
    self.customer_token = customer_token
    preorder!
    log_accounting_for_preordered_order
  end

  def capture_stripe_customer_payment(customer_token, options = {})
    transaction do
      capture = Payment.stripe_customer_capture(integer_amount_charge, customer_token, order.number, options)
      if capture.paid
        self.charge_token = capture.id #  charge_token
        payment_charge!
        capture_complete_order
      else
        transaction_declined!
      end
      capture
    end
  end
  def integer_amount_charge
    (amount_charged * 100.0).to_i
  end

  def amount_charged
    amount - credited_amount
  end

  def capture_complete_order
    if batches.empty?
      # this means we never authorized just captured payment
      capture_complete_order_without_authorization
    else
      capture_authorized_order
    end
  end

  def capture_authorized_order
    batch       = batches.first
    batch.transactions.push(CreditCardReceivePayment.new_capture_authorized_payment(order.user, amount, decimal_tax_amount))
    batch.save
  end

  def capture_complete_order_without_authorization
    batch = self.batches.create()
    batch.transactions.push(CreditCardCapture.new_capture_payment_directly(order.user, amount, decimal_tax_amount))
    batch.save
  end

  def log_accounting_for_preordered_order
    batch = self.batches.create()
    batch.transactions.push(CreditCardPreorder.new_preorder_payment(order.user, amount, decimal_tax_amount))
    batch.save
  end

  def authorize_complete_order#(amount)
    order.complete!
    if batches.empty?
      batch = self.batches.create()
      batch.transactions.push(CreditCardPayment.new_authorized_payment(order.user, amount, decimal_tax_amount))
      batch.save
    else
      raise error ###  something messed up I think
    end
  end

  def decimal_tax_amount
    (tax_amount.to_f / 100.0).round_at(2)
  end

  def cancel_authorized_payment
    batch       = batches.first
    if batch# if not we never authorized the payment
      batch.transactions.push(CreditCardCancel.new_cancel_authorized_payment(order.user, amount, decimal_tax_amount))
      self.return_money_and_cancel!
      batch.save
    end
  end

  def cancel_paid_payment
    batch       = batches.first
    if batch# if not we never authorized the payment
      batch.transactions.push(CreditCardCancel.new_cancel_paid_payment(order.user, amount, decimal_tax_amount))
      self.cancel!
      batch.save
    else
      raise error_no_batch_hence_something_is_wrong
    end
  end

  def self.process_rma(return_amount, order)
    transaction do
      this_invoice = Invoice.new(:order => order, :amount => return_amount, :invoice_type => RMA)
      this_invoice.save
      this_invoice.complete_rma_return
      this_invoice.payment_rma!
      this_invoice
    end
  end

  def complete_rma_return
    batch       = batches.first || self.batches.create()
    batch.transactions.push(ReturnMerchandiseComplete.new_complete_rma(order.user, amount, decimal_tax_amount))
    batch.save
  end


  # call to find the confirmation_id sent by the payment processor.
  #
  # @param [none]
  # @return [String] id the payment processor sends you after authorization.
  def authorization_reference
    if authorization = payments.find_by_action_and_success('authorization', true, :order => 'id ASC')
      authorization.confirmation_id #reference
    end
  end

  # call to find out if the transaction has succeeded.
  #
  # @param [none]
  # @return [Boolean] returns true if the invoice is paid or has been authorized for payment
  def succeeded?
    authorized? || paid?
  end

  # call to find out the amount of the invoice in cents
  #
  # @param [none]
  # @return [Integer] amount of the invoice in cents
  def integer_amount
    times_x_amount = amount.integer? ? 1 : 100
    (amount * times_x_amount).to_i
  end

  # find the user id of the order associated to the invoice.
  #
  # @param [none]
  # @return [Integer] represents the id of the user
  def user_id
    order.user_id
  end

  # find the user of the order associated to the invoice.
  #
  # @param [none]
  # @return [User]
  def user
    order.user
  end

  def self.admin_grid(args)
    if args[:order_number].present?
      where("orders.number = ?", args[:order_number])
    elsif args[:email].present?
      where("orders.email = ?", args[:email])
    else
      scoped
    end
  end

  private

  def return_money
    if charge_token && !order.shipped? && charge_token.present?
      @stripe_charge ||= Stripe::Charge.retrieve(charge_token)
      @stripe_charge.refund()
    end
  end

  def unique_order_number
    "#{Time.now.to_i}-#{rand(1000000)}"
  end
end
