module TransactionAccountable

  def new_credit(transaction_account_id, credit_amount, tax_amount, at = Time.zone.now)
    credit = new_transaction(transaction_account_id, 0, credit_amount, tax_amount, at)
  end

  def new_debit(transaction_account_id, debit_amount, tax_amount, at = Time.zone.now)
    debit = new_transaction(transaction_account_id, debit_amount, 0, tax_amount, at)
  end

  private
    def new_transaction(transaction_account_id, debit_amount, credit_amount, tax_amount, at)
      self.transaction_ledgers.new(:transaction_account_id => transaction_account_id, :tax_amount =>tax_amount, :debit => debit_amount, :credit => credit_amount, :period => "#{at.month}-#{at.year}")
    end
end
