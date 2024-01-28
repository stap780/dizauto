class Product::ImportSaveData

    def initialize(data)
        puts '======'
        p data
        puts '======'
        @data = data
        @images = @data[:images].to_s.present? ? @data[:images] : nil
        @pr_data = @data.except!(:images)
        @product = nil
    end

    def call
        create_update_product
        create_update_image
    end

    private

    def create_update_product
        s_product = Product.find_by_barcode(@pr_data[:barcode])
        if s_product
          puts 'find product'
          s_product.update!(@pr_data.except!(:props_attributes)) if s_product.props.present? #for future we need prop update
          s_product.update!(@pr_data) if !s_product.props.present?
          @product = s_product
        else
          puts 'create product'
          @product = Product.create!(@pr_data)
        end
        @product
    end

    def create_update_image
        ProductImageJob.perform_later(@product.id, @images)
    end

end