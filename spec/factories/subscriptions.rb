# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    subscription_plan { |c| c.association(:subscription_plan) }
    user       { |c| c.association(:user) }
    order_item { |c| c.association(:order_item) }
    stripe_customer_token "MyString"
    next_bill_date {Time.zone.now + 1.month}
    total_payments nil
    shipping_address { |c| c.association(:address) }
    billing_address  { |c| c.association(:address) }
  end
end
