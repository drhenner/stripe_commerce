FactoryGirl.define do
  factory :payment_profile do
    user            { |c| c.association(:user) }
    address         { |c| c.association(:address) }
    payment_cim_id  123456789
    default         true
    active          true
    cc_type         'visa'
    month           '05'
    year            '2013'
    #last_digits     '3955'
    customer_token  'fakeCCtoken'
  end
end
