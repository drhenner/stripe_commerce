# == Schema Information
#
# Table name: transactions
#
#  id         :integer(4)      not null, primary key
#  type       :string(255)
#  batch_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class SubscriptionTransaction < Transaction
  def self.new_authorized_payment(transacting_subscription, total_cost, tax_amount, at = Time.zone.now)
    transaction = SubscriptionTransaction.new()
    transaction.new_transaction_ledgers( transacting_subscription, TransactionAccount::REVENUE_ID, TransactionAccount::ACCOUNTS_RECEIVABLE_ID, total_cost, tax_amount, at)
    transaction
  end

  def self.new_cancel_authorized_payment(transacting_subscription, total_cost, tax_amount, at = Time.zone.now)
    transaction = SubscriptionTransaction.new()
    transaction.new_transaction_ledgers( transacting_subscription, TransactionAccount::ACCOUNTS_RECEIVABLE_ID, TransactionAccount::REVENUE_ID, total_cost, tax_amount, at)
    transaction
  end

  def self.new_capture_payment(transacting_subscription, total_cost, tax_amount, at = Time.zone.now)
    transaction = SubscriptionTransaction.new()
    transaction.new_transaction_ledgers( transacting_subscription, TransactionAccount::ACCOUNTS_RECEIVABLE_ID, TransactionAccount::CASH_ID, total_cost, tax_amount, at)
    transaction
  end

  def self.new_cancel_captured_payment(transacting_subscription, total_cost, tax_amount, at = Time.zone.now)
    transaction = SubscriptionTransaction.new()
    transaction.new_transaction_ledgers( transacting_subscription, TransactionAccount::CASH_ID, TransactionAccount::REVENUE_ID, total_cost, tax_amount, at)
    transaction
  end
end

