# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription_plan do
    name "MyString"
    stripe_id "MyString"
    amount 1
    total_payments 1
    interval "month"
  end
end
