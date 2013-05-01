class Admin::Merchandise::ImageGroupsController < Admin::BaseController
  helper_method :sort_column, :sort_direction, :products
  def index
    params[:page] ||= 1
    params[:rows] ||= 20
    @image_groups = ImageGroup.order(sort_column + " " + sort_direction).
                                              paginate(:page => params[:page].to_i, :per_page => params[:rows].to_i)
  end

  def show
    @image_group = ImageGroup.find(params[:id])
  end

  def new
    @image_group = ImageGroup.new
  end

  def create
    @image_group = ImageGroup.new(params[:image_group])
    if @image_group.save
      redirect_to edit_admin_merchandise_image_group_url( @image_group ), :notice => "Successfully created image group."
    else
      render :new
    end
  end

  def edit
    @image_group  = ImageGroup.includes(:images).find(params[:id])
  end

  def update
    @image_group = ImageGroup.find(params[:id])
    if @image_group.update_attributes(params[:image_group])
      redirect_to [:admin, :merchandise, @image_group], :notice  => "Successfully updated image group."
    else
      render :edit
    end
  end

  private

    def products
      @products ||= Product.all.map{|p|[p.name, p.id]}
    end

    def sort_column
      ImageGroup.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
