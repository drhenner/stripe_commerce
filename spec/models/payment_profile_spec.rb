require 'spec_helper'

describe PaymentProfile, ".create_payment_profile" do
  context "last_4_digits=(digits)" do
    it 'should set the last 4 digits' do
      Stripe::Customer.stubs(:create).returns({'id' => 'testTOKEN'})
      payment_profile = create(:payment_profile)
      payment_profile.last_4_digits=('4113')
      payment_profile.last_digits.should_not eq '4113'
      payment_profile.last_digits.should_not be_blank
      payment_profile.save
      payment_profile.reload
      payment_profile.last4.should eq '4113'
    end
  end
end
