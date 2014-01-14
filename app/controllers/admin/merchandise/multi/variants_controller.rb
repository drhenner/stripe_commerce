class Admin::Merchandise::Multi::VariantsController < Admin::BaseController
  helper_method :subscription_plans, :image_groups, :taxability_informations
  def edit
    @product        = Product.includes(:properties,:product_properties, {:prototype => :properties}).find(params[:product_id])
    form_info
  end

  def update
    @product = Product.find(params[:product_id])

    if @product.update_attributes(allowed_params)
      flash[:notice] = "Successfully updated variants"
      redirect_to admin_merchandise_product_url(@product)
    else
      form_info
      render :action => :edit, :layout => 'admin_markup'
    end
  end
  private

  def allowed_params
    params.require(:product).permit!
    #permit({:variants_attributes => [:id, :product_id, :sku, :name, :price, :cost, :deleted_at, :master, :brand_id, :inventory_id]} )
  end

  def form_info
    @brands = Brand.all.collect{|b| [b.name, b.id] }
  end

  def image_groups
    @image_groups ||= ImageGroup.where(:product_id => @product).map{|i| [i.name, i.id]}
  end

  def subscription_plans
    @subscription_plans ||= SubscriptionPlan.all.map{|b| [b.name, b.id] }
  end

  def taxability_informations
    @taxability_informations ||= TaxabilityInformation.all.map{|b| ["#{b.name}(#{b.code})", b.id] }
  end
end
