class PreordersController < ApplicationController
  helper_method :upsells
  skip_before_filter :redirect_to_welcome
  before_filter :redirect_unless_preorder
  before_filter :redirect_if_accepting_orders
  layout 'preorder'

  def index
    @products = Product.preorders
    if session_cart.shopping_cart_items.empty?
      redirect_to root_url
    end
  end

  def show
    #@product = Product.preorders.find(params[:id])
    redirect_to preorders_url
  end

  # this adds the default preorder to the cart
  def create
    session_cart.add_default_presale_sale(most_likely_user)
    redirect_to preorders_url
  end

  private
    def redirect_if_accepting_orders
      redirect_to products_url and return if Settings.allow_orders
    end

    def upsells
      @upsells ||= Variant.includes([:product,{:image_group => :images}]).upsells.limit(3).all
    end

end
