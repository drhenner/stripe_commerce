# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :signup do
    sequence(:email)      { |n| "signup#{n}@example.com" }
  end
end
