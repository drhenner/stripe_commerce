class Admin::Config::SubscriptionPlansController < Admin::Config::BaseController
  helper_method :sort_column, :sort_direction
  def index
    params[:page] ||= 1
    params[:rows] ||= 20
    @subscription_plans = SubscriptionPlan.order(sort_column + " " + sort_direction).
                                              paginate(:page => params[:page].to_i, :per_page => params[:rows].to_i)
  end

  def show
    @subscription_plan = SubscriptionPlan.find(params[:id])
  end

  def new
    @subscription_plan = SubscriptionPlan.new
  end

  def create
    @subscription_plan = SubscriptionPlan.new(allowed_params)
    if @subscription_plan.save
      redirect_to [:admin, :config, @subscription_plan], :notice => "Successfully created subscription plan."
    else
      render :new
    end
  end

  def edit
    @subscription_plan = SubscriptionPlan.find(params[:id])
  end

  def update
    @subscription_plan = SubscriptionPlan.find(params[:id])
    if @subscription_plan.update_attributes(allowed_params)
      redirect_to [:admin, :config, @subscription_plan], :notice  => "Successfully updated subscription plan."
    else
      render :edit
    end
  end

  private

    def allowed_params
      params.require(:subscription_plan).permit!
    end

    def sort_column
      SubscriptionPlan.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
end
