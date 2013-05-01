class Admin::Shopping::Checkout::OrdersController < Admin::Shopping::Checkout::BaseController
  helper_method :customer
  ### The intent of this action is two fold
  #
  # A)  if there is a current order redirect to the process that
  # => needs to be completed to finish the order process.
  # B)  if the order is ready to be checked out...  give the order summary page.
  #
  ##### THIS METHOD IS BASICALLY A CHECKOUT ENGINE
  def show
    authorize! :create_orders, current_user

    @order = find_or_create_order
    #@order = session_admin_cart.add_items_to_checkout(order) # need here because items can also be removed
    if f = next_admin_order_form()
      redirect_to f
    else
      if @order.order_items.empty?
        redirect_to admin_shopping_products_url() and return
      end
      form_info
    end
  end

  def total
    @order = find_or_create_order
    @order.credited_total
    respond_to do |format|
      format.json  { render :json => @order.to_json(:only => [:number, :integer_credited_total], :methods => [:integer_credited_total]) }
    end
  end

  def start_checkout_process
    authorize! :create_orders, current_user

    order = session_admin_order
    @order = session_admin_cart.add_items_to_checkout(order) # need here because items can also be removed
    if session_admin_cart.number_of_shopping_cart_items != @order.order_items.size
      flash[:alert] = "Some items could not be added to the cart.  Out of Stock."
    end
    redirect_to next_admin_order_form_url
  end

  def update
    @order = session_admin_order
    @order.ip_address = request.remote_ip

    form_info

    address = @order.bill_address.cc_params

    if @order.complete?
      session_admin_cart.mark_items_purchased(@order)
      flash[:alert] = I18n.t('the_order_purchased')
      redirect_to admin_history_order_url(@order)
    elsif payment_profile
      @order.payment_profile = @payment_profile
      @order.save
      if invoice = @order.create_invoice(@credit_card,
                                          @order.credited_total,
                                          payment_profile,
                                          @order.amount_to_credit)
        if invoice.succeeded?
          order_completed!(@order)
          redirect_to admin_history_order_url(@order)
        else
          flash[:alert] =  [I18n.t('could_not_process'), I18n.t('the_order')].join(' ')
          render :action => "show"
        end
      else
        flash[:alert] = [I18n.t('could_not_process'), I18n.t('the_credit_card')].join(' ')
        render :action => 'show'
      end
    else
      flash[:alert] = [I18n.t('credit_card'), I18n.t('is_not_valid')].join(' ')
      render :action => 'show'
    end
  end

  private

  def show_right_panel_summary
    true
  end

  def form_info
    @payment_profiles = customer.active_payment_profiles
    @order.credited_total
  end

  def customer
    @customer ||= @order.user
  end

  def payment_profile
    return @payment_profile if @payment_profile
    if create_a_new_profile?
      @payment_profile = @order.user.payment_profiles.new(cc_params)
      @payment_profile.active = save_card?
      @payment_profile.save!
      @payment_profile
    elsif params[:use_credit_card_on_file].present? #charge the profile
      @payment_profile = @order.user.payment_profiles.find_by_id(params[:use_credit_card_on_file])
    end
  end

  def create_a_new_profile?
    params[:stripe_card_token].present?
  end

  def save_card?
    params[:save_card] == '1'
  end

  def cc_params
    {
    "card_name"         => params[:full_name],
    "stripe_card_token" => params[:stripe_card_token],
    "cc_type"           => params[:brand],
    "month"             => params[:month],
    "year"              => params[:year],
    "active"            => save_card?,
    :address_id         => @order.bill_address_id}
  end

end

