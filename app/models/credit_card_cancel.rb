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

class CreditCardCancel < Transaction
  def self.new_cancel_authorized_payment(transacting_user, total_cost, tax_amount, at = Time.zone.now)
    transaction = CreditCardCancel.new()
    transaction.new_transaction_ledgers( transacting_user, TransactionAccount::ACCOUNTS_RECEIVABLE_ID, TransactionAccount::REVENUE_ID, total_cost, tax_amount, at)
    transaction
  end
  def self.new_cancel_paid_payment(transacting_user, total_cost, tax_amount, at = Time.zone.now)
    transaction = CreditCardCancel.new()
    transaction.new_transaction_ledgers( transacting_user, TransactionAccount::CASH_ID, TransactionAccount::REVENUE_ID, total_cost, tax_amount, at)
    transaction
  end
end
