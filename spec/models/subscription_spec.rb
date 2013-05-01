require 'spec_helper'

describe Subscription do
  context "cancel!" do
    it "should cancel the order" do
      subscription = FactoryGirl.create(:subscription, :active => true, :canceled => false, :remaining_payments => 1000, :next_bill_date => Date.today + 3.days)
      subscription.cancel!
      expect(subscription.canceled).to eq true
    end
    it "should inactivate the order" do
      subscription = FactoryGirl.create(:subscription, :active => true, :canceled => false, :remaining_payments => 1000, :next_bill_date => Date.today + 3.days)
      subscription.cancel!
      expect(subscription.active).to eq false
    end
    it "should set the remaining_payments to ZERO" do
      subscription = FactoryGirl.create(:subscription, :active => true, :canceled => false, :remaining_payments => 1000, :next_bill_date => Date.today + 3.days)
      subscription.cancel!
      expect(subscription.remaining_payments).to eq 0
    end
  end
end
