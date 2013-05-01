# This controller has two purposes.
#
#  1) add an upsell to the cart
#  2) remove an upsell from the cart
#

class UpsellsController < ApplicationController
  helper_method :sort_column, :sort_direction

  # params[:id] is variant_id
  def update
    session_cart.save if session_cart.new_record?
    qty = params[:quantity] ? params[:quantity].to_i : 1
    #cart_item = session_cart.add_variant(params[:id], most_likely_user, qty)
    cart_item = session_cart.add_upsell(params[:id], most_likely_user, qty)
    redirect_to(preorders_url(:anchor => 'order-summary'))
  end

  # params[:id] is cart_item_id
  def destroy
    session_cart.cart_items.find_by_id(params[:id]).try(:inactivate!)
    redirect_to(preorders_url(:anchor => 'order-summary'))
  end

  private

    def sort_column
      Upsell.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
