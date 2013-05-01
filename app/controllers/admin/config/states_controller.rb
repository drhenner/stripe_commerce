class Admin::Config::StatesController < Admin::Config::BaseController
  helper_method :sort_column, :sort_direction, :shipping_zones, :countries
  def index
    params[:page] ||= 1
    params[:rows] ||= 25
    @states = State.order(sort_column + " " + sort_direction).
                                              paginate(:page => params[:page].to_i, :per_page => params[:rows].to_i)
  end

  def show
    @state = State.find(params[:id])
  end

  def new
    @state = State.new
  end

  def create
    @state = State.new(params[:state])
    if @state.save
      redirect_to [:admin, :config, @state], :notice => "Successfully created state."
    else
      render :new
    end
  end

  def update
    @state = State.find(params[:id])
    @state.activate!
    redirect_to admin_config_states_url, :notice => "Successfully destroyed state."
  end

  def destroy
    @state = State.find(params[:id])
    @state.inactivate!
    redirect_to admin_config_states_url, :notice => "Successfully destroyed state."
  end

  private

    def shipping_zones
      @shipping_zones ||= ShippingZone.all.map{|sz| [sz.name, sz.id]}
    end

    def countries
      @countries    ||= Country.form_selector
    end

    def sort_column
      State.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
