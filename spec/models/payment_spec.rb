require 'spec_helper'

describe Payment, " instance methods" do

end

describe Payment, " class methods" do
  before(:each) do
    @amount = 100
  end

  context '.stripe_customer_capture(integer_amount, customer_token, order_number, options)' do
    it 'Should capture the stripe CC payment'
  end

  #context "#process(action, amount = nil)" # This method is being exersized by many other methods
end
