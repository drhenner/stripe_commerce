class Admin::UsersController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
   # @users = User.find( :all)
    authorize! :view_users, current_user
    # @users = User.admin_grid(params)
    @users = User.admin_grid(params).order(sort_column + " " + sort_direction).
                                    paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  def show
    @user = User.includes([:shipments, :finished_orders, :return_authorizations, :comments]).find(params[:id])
    add_to_recent_user(@user)
  end

  def new
    @user = User.new
    authorize! :create_users, current_user
    form_info
  end

  def create
    @user = User.new(user_params)
    @user.format_birth_date(params[:user][:birth_date]) if params[:user][:birth_date].present?
    authorize! :create_users, current_user
    if @user.save
      Resque.enqueue(Jobs::SendRegistrationEmail, @user.id)
      @user.active? || @user.activate! if @user.send(:password_changed?)
      add_to_recent_user(@user)
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to admin_users_url
    else
      form_info
      render :action => :new
    end
  end

  def edit
    @user = User.includes(:roles).find(params[:id])
    authorize! :create_users, current_user
    form_info
  end

  def update
    params[:user][:role_ids] ||= []
    @user = User.includes(:roles).find(params[:id])
    authorize! :create_users, current_user
    @user.format_birth_date(params[:user][:birth_date]) if params[:user][:birth_date].present?
    if @user.update_attributes(user_params)
      flash[:notice] = "#{@user.name} has been updated."
      redirect_to admin_users_url
    else
      form_info
      render :action => :edit
    end
  end

  private

  def user_params
    if current_user.super_admin?
      params.require(:user).permit(:password, :password_confirmation, :first_name, :last_name, :email, :state, :role_ids => [])
    else
      params.require(:user).permit(:password, :password_confirmation, :first_name, :last_name, :email, :state)
    end
  end

  def role_saving
    current_user.super_admin? ? {:as => :super_admin} : {:as => :admin}
  end

  def form_info
    @all_roles = Role.all
    @states    = ['inactive', 'active', 'canceled', 'signed_up']
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "users.id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
