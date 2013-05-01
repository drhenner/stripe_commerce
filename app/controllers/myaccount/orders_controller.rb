class Myaccount::OrdersController < Myaccount::BaseController
  # GET /myaccount/orders
  # GET /myaccount/orders.xml
  def index
    @orders = current_user.viewable_orders.
                           find_myaccount_details.
                           order( 'orders.completed_at DESC' ).
                           paginate(:page => pagination_page, :per_page => 8)
  end

  # GET /myaccount/orders/1
  def show
    @order = current_user.viewable_orders.
                          includes([:invoices, :ship_address, :bill_address, {:order_items => {:variant => :product}}]).
                          find_by_number(params[:id])
  end
  private

  def selected_myaccount_tab(tab)
    tab == 'orders'
  end
end
