class CreditCardPreorder < Transaction
  # call the following to log capturing this transaction
  # new_capture_authorized_payment(transacting_user, total_cost, tax_amount, at = Time.zone.now)
  def self.new_preorder_payment(transacting_user, total_cost, tax_amount, at = Time.zone.now)
    transaction = CreditCardPreorder.new()
    transaction.new_transaction_ledgers( transacting_user, TransactionAccount::REVENUE_ID, TransactionAccount::ACCOUNTS_RECEIVABLE_ID, total_cost, tax_amount, at)
    transaction
  end

end
