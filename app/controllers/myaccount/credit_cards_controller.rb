class Myaccount::CreditCardsController < Myaccount::BaseController
  def index
    @credit_cards = current_user.active_payment_profiles.
                                 order( 'payment_profiles.id DESC' ).
                                 paginate(:page => pagination_page, :per_page => 12)
  end

  def new
  end

  def create
    if payment_profile
      flash[:notice] = "Successfully created credit card."
      redirect_to myaccount_credit_cards_url()
    else
      render :action => 'new'
    end
  end

  def destroy
    @credit_card = current_user.payment_profiles.find(params[:id])
    @credit_card.inactivate!
    flash[:notice] = "Successfully removed credit card."
    redirect_to myaccount_credit_cards_url
  end

  private

  def selected_myaccount_tab(tab)
    tab == 'credit_cards'
  end

  def payment_profile
    return @payment_profile if @payment_profile
    if create_a_new_profile?
      @payment_profile = current_user.payment_profiles.new(cc_params)
      @payment_profile.active = true
      @payment_profile.save!
      @payment_profile
    elsif params[:use_credit_card_on_file].present? #charge the profile
      @payment_profile = current_user.payment_profiles.find_by_id(params[:use_credit_card_on_file])
    end
  end

  def cc_params
    {"first_name"       => params[:first_name],
    "last_name"         => params[:last_name],
    "stripe_card_token" => params[:stripe_card_token],
    "cc_type"           => params[:brand],
    "month"             => params[:month],
    "year"              => params[:year],
    "active"            => true}
  end

  def create_a_new_profile?
    params[:stripe_card_token].present?
  end

end
