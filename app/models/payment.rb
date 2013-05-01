# == Schema Information
#
# Table name: payments
#
#  id              :integer(4)      not null, primary key
#  invoice_id      :integer(4)
#  confirmation_id :string(255)
#  amount          :integer(4)
#  error           :string(255)
#  error_code      :string(255)
#  message         :string(255)
#  action          :string(255)
#  params          :text
#  success         :boolean(1)
#  test            :boolean(1)
#  created_at      :datetime
#  updated_at      :datetime
#

class Payment < ActiveRecord::Base
  belongs_to :invoice

  serialize :params
  # this is initialized to an instance of ActiveMerchant::Billing::Base.gateway
  #cattr_accessor :gateway

  validates :amount,      :presence => true
  validates :invoice_id,  :presence => true

  class << self

      def stripe_customer_capture(integer_amount, customer_token, order_number, options)
        if integer_amount > 50
          stripe_charge = Stripe::Charge.create(
              :amount => integer_amount,
              :currency => "usd",
              :customer => customer_token,
              :description => "Charge for #{order_number}" )
          # Best to save the payment details now!
          #save_payment_details(stripe_charge)
        else
          #  Return a true paid object
          free_transaction_fake_data(integer_amount, customer_token, order_number)
        end
      end

      def free_transaction_fake_data(integer_amount, customer_token, order_number)
        FreeCharge.new(integer_amount, customer_token, order_number)
      end


    private

      def save_payment_details(stripe_charge)
        result = Payment.new
        result.amount = stripe_charge.amount
        result.action = stripe_charge.action
          begin
            result.success    = stripe_charge.success?
            result.confirmation_id  = stripe_charge.customer_token
            result.message    = stripe_charge.message
            result.params     = stripe_charge.params
            result.test       = stripe_charge.test?
          rescue e
            #puts e
            result.success = false
            result.confirmation_id = nil
            result.message = e.message
            result.params = {}
            result.test = stripe_charge.try(:test?)
          end
        result
      end
  end
end
