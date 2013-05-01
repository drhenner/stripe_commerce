class Admin::SignupsController < Admin::BaseController
  helper_method :sort_column, :sort_direction
  def index
    @signups = Signup.order(sort_column + " " + sort_direction).
                            paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  def show
    @signup = Signup.find(params[:id])
    @user   = User.where('email = ?', @signup.email).first
  end

  def new
    @signup = Signup.new
  end

  def create
    @signup = Signup.new(params[:signup])
    if @signup.save
      redirect_to [:admin, @signup], :notice => "Successfully created signup."
    else
      render :new
    end
  end

  def edit
    @signup = Signup.find(params[:id])
  end

  def update
    @signup = Signup.find(params[:id])
    if @signup.update_attributes(params[:signup])
      redirect_to [:admin, @signup], :notice  => "Successfully updated signup."
    else
      render :edit
    end
  end

  def destroy
    @signup = Signup.find(params[:id])
    @signup.destroy
    redirect_to admin_signups_url, :notice => "Successfully destroyed signup."
  end

  private

    def sort_column
      Signup.column_names.include?(params[:sort]) ? params[:sort] : "signups.id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
