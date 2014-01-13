class ProductType < ActiveRecord::Base
  acts_as_nested_set  #:order => "name"
  has_many :products, dependent: :restrict_with_exception

  validates :name,    :presence => true, :length => { :maximum => 255 }

  FEATURED_TYPE_ID = 1

  after_save :expire_cache

  # paginated results from the admin ProductType grid
  #
  # @param [Optional params]
  # @return [ Array[ProductType] ]
  def self.admin_grid(params = {})
    grid = ProductType
    grid = grid.where("product_types.name LIKE ?", "#{params[:name]}%")              if params[:name].present?
    grid
  end

  def self.upsell_product_type_ids
    Rails.cache.delete("upsell_product_type_ids") if Rails.env == 'test'
    Rails.cache.fetch("upsell_product_type_ids", :expires_in => 3.hours) do
      ids = ProductType.where("product_types.name NOT LIKE ?", 'Media').pluck(:id)
      ids.empty? ? [ProductType.first.id] : ids
    end
  end

  def self.main_preorder_product_type_ids
    Rails.cache.delete("main_preorder-product_type_ids") if Rails.env == 'test'
    Rails.cache.fetch("main_preorder-product_type_ids", :expires_in => 3.hours) do
      ids = ProductType.where("product_types.name LIKE ?", 'Media').pluck(:id)
      ids.empty? ? [ProductType.first.id] : ids
    end
  end

  private
    def expire_cache
      Rails.cache.delete("Variant-default_preorder_item_ids")
      Rails.cache.delete("main_preorder-product_type_ids")
      Rails.cache.delete("upsell_product_type_ids")
    end

end
