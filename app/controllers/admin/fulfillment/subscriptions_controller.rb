class Admin::Fulfillment::SubscriptionsController < Admin::Fulfillment::BaseController
  helper_method :sort_column, :sort_direction, :user_addresses
  def index
    @subscriptions = Subscription.active.includes([:user, {:order_item => :order}]).order(sort_column + " " + sort_direction).
                    with_email(params[:email]).
                    paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  def show
    @subscription = Subscription.includes([{:user => :shipping_addresses}, {:order_item => :order}]).find(params[:id])
    add_to_recent_user(@subscription.user)
  end

  def edit
    @subscription = Subscription.find(params[:id])
    add_to_recent_user(@subscription.user)
  end

  def update
    @subscription = Subscription.find(params[:id])
    if @subscription.update_attributes(params[:subscription], :as => :admin)
      redirect_to [:admin, :fulfillment, @subscription], :notice  => "Successfully updated subscription."
    else
      render :edit
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.cancel!
    redirect_to admin_fulfillment_subscription_url(@subscription), :notice => "Successfully destroyed subscription."
  end

  private
    def user_addresses
      @subscription.user.shipping_addresses.map{|a| ["#{a.name}: #{a.address_lines} - #{a.city}" , a.id]}
    end

    def sort_column
      Subscription.column_names.include?(params[:sort]) ? params[:sort] : "subscriptions.user_id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
