class Shopping::PaymentsController < Shopping::BaseController
  helper_method :payment_profiles
  layout 'checkout'

  def index

  end

  def create
    @payment_profile = current_user.payment_profiles.new(cc_params)
    if @payment_profile.save
      update_order_payment_profile_id(@payment_profile.id)
      redirect_to shopping_orders_url
    else
      render :index, :alert => 'Something went wrong!'
    end
  end

  #  update
  def select_card
    payment_profile = current_user.active_payment_profiles.find(params[:id])
    update_order_payment_profile_id(payment_profile.id)
    redirect_to shopping_orders_url
  end

  private
  def cc_params
    {"first_name"       => params[:first_name],
    "last_name"         => params[:last_name],
    "card_name"         => params[:full_name],
    "stripe_card_token" => params[:stripe_card_token],
    "cc_type"           => params[:brand],
    "month"             => params[:month],
    "year"              => params[:year],
    #'last_4_digits'     => params[:last4],
    "active"            => save_card?,
    :address_id         => session_order.bill_address_id}
  end

  def save_card?
    params[:save_card] == '1' || params[:save_card] == 'on'
  end

  def payment_profiles
    @payment_profiles ||= current_user.active_payment_profiles
  end

  def update_order_payment_profile_id(payment_profile_id)
    session_order.update_attributes( :payment_profile_id => payment_profile_id )
  end

  def selected_checkout_tab(tab)
    tab == 'payment-info'
  end
end
