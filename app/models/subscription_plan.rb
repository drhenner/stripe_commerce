class SubscriptionPlan < ActiveRecord::Base

  has_many  :variants
  has_many  :subscriptions

  validates :amount,        :presence => true, :numericality => true
  validates :interval,      :presence => true
  validates :name,          :presence => true
  validates :stripe_id,     :presence => true
  validates :total_payments,  :presence => true

  PLANS = ['month']

  def decimal_amount
    (amount.to_f / 100.0).round_at(2)
  end

end
