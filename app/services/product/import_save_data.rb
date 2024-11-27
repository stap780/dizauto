class Product::ImportSaveData
  
  def initialize(data)
    # puts "Product::ImportSaveData ======"
    # p data
    # puts "======"
    @data = data
    @images = @data[:images].to_s.present? ? @data[:images] : nil
    @pr_data = @data.except!(:barcode, :images, :sku, :quantity, :cost_price, :price)
    @var_data = @data.except!(:title, :description, :video, :props_attributes, :images)
    @product = nil
  end

  def call
    create_update_product
    create_update_image
  end

  private

  def create_update_product
    # s_product = Product.find_by_barcode(@pr_data[:barcode])
    s_product = Variant.find_by_barcode(@var_data[:barcode]).present? ? Variant.find_by_barcode(@var_data[:barcode]).product : nil
    if s_product.present?
      # puts "we find s_product"
      # s_product.update!(@pr_data.except!(:props_attributes)) if s_product.props.present? # for future we need prop update
      # s_product.update!(@pr_data) if !s_product.props.present?
      s_product.props.size == 0 ? s_product.update!(@pr_data) : s_product.update!(@pr_data.except!(:props_attributes))
      
      # for future we need prop update
      
      s_product.variants.create!(@var_data) if s_product.variants.size == 0
      @product = s_product
    else
      @product = Product.create!(@pr_data)
      @product.variants.create!(@var_data)
    end
    @product
  end

  def create_update_image
    ProductImageJob.perform_later(@product.id, @images)
  end

end
