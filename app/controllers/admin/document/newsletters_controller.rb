class Admin::Document::NewslettersController < Admin::BaseController
  helper_method :sort_column, :sort_direction
  def index
    @newsletters = Newsletter.order(sort_column + " " + sort_direction).
                              paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  def show
    @newsletter = Newsletter.find(params[:id])
  end

  def new
    @newsletter = Newsletter.new
  end

  def create
    @newsletter = Newsletter.new(params[:newsletter])
    if @newsletter.save
      redirect_to [:admin, :document, @newsletter], :notice => "Successfully created newsletter."
    else
      render :new
    end
  end

  def edit
    @newsletter = Newsletter.find(params[:id])
  end

  def update
    @newsletter = Newsletter.find(params[:id])
    if @newsletter.update_attributes(params[:newsletter])
      redirect_to [:admin, :document, @newsletter], :notice  => "Successfully updated newsletter."
    else
      render :edit
    end
  end

  def destroy
    @newsletter = Newsletter.find(params[:id])
    @newsletter.destroy
    redirect_to admin_document_newsletters_url, :notice => "Successfully destroyed newsletter."
  end

  private

    def sort_column
      Newsletter.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
