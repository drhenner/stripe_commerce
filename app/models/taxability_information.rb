class TaxabilityInformation < ActiveRecord::Base
  attr_accessible :code, :name
  has_many :variants

  validates :name,  :presence => true
  validates :code,  :presence => true

  CODES = {'Clothes' => '20010', 'Videos' => '31040', 'Subscriptions' => '30070', 'Dietary Supplement' => '40020'}
end
