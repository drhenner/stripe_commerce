namespace :preorder do
  task :receive_payment_for_available_items => :environment do
    # Get the orders that are preordered
    OrderItem.preorders.find_each do |item|
      item
    end
    Order.preorders.find_each do |order|
      Order.uncached do
        if order.all_in_stock?
          Order.transaction do
            order.pay!
            order.update_inventory

            invoice_statement = Invoice.where('order_id = ?', order.id).last
            invoice_statement.capture_stripe_customer_payment(invoice_statement.customer_token)
          end
        end
      end
      # now we need to send the 3PL the info.  response should eventually have the shipping info.
    end
  end
end
