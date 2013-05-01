class Admin::NewslettersController < Admin::BaseController
  helper_method :sort_column, :sort_direction, :customer, :newsletters
  def index
    @newsletters = customer.newsletters.order(sort_column + " " + sort_direction).
                                        paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  def show
    @newsletter = Newsletter.find(params[:id])
  end

  def edit
  end

  def update
    if customer.update_attributes(params[:user])
      redirect_to admin_user_newsletters_url(customer), :notice  => "Successfully updated #{customer.name} newsletters."
    else
      render :edit
    end
  end

  def destroy
    @users_newsletter = UsersNewsletter.find(params[:id])
    @users_newsletter.destroy
    redirect_to admin_user_newsletters_url(customer), :notice => "Successfully destroyed newsletter."
  end

  private

    def customer
      customer ||= User.includes(:newsletters).where(:id => params[:user_id]).first()
    end

    def newsletters
      @all_newsletters ||= Newsletter.all
    end

    def sort_column
      Newsletter.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
