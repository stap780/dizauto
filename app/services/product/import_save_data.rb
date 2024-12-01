class Product::ImportSaveData < ApplicationService
  
  def initialize(data)
    @data = data
    @images = @data[:images]
    @pr_data = @data.except(:barcode, :images, :sku, :quantity, :cost_price, :price)
    @var_data = @data.except(:title, :description, :video, :props_attributes, :images)
    @product = nil
  end

  def call
    create_update_product
    create_update_image
  end

  private

  def create_update_product
	  puts "@pr_data => #{@pr_data}"
	  puts "@var_data => #{@var_data}"
    # s_product = Product.find_by_barcode(@pr_data[:barcode])
    s_product = Variant.find_by_barcode(@var_data[:barcode]).present? ? Variant.find_by_barcode(@var_data[:barcode]).product : nil
    if s_product.present?
      s_product.props.size.zero? ? s_product.update!(@pr_data) : s_product.update!(@pr_data.except!(:props_attributes))

      # for future we need prop update

      s_product.variants.create!(@var_data) if s_product.variants.size.zero?
      @product = s_product
    else
      @product = Product.create!(@pr_data)
      @product.variants.create!(@var_data)
    end
    @product
  end

  def create_update_image
    ProductImageJob.perform_later(@product.id, @images) if @data[:images].present?
  end

end
