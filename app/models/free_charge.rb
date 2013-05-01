class FreeCharge
  def initialize(integer_amount, customer_token, order_number)
    @amount = integer_amount
    @customer_token = customer_token
    @order_number = order_number
  end

  def paid
    paid?
  end
  def paid?
    true
  end

  def customer
    @customer_token
  end

  def amount
    @amount
  end

  def order_number
    @order_number
  end

  def id
    'free_charge'
  end

  def description
    "Charge for #{order_number}"
  end
end
