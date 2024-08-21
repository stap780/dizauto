class Product::PriceUpdate

    def initialize(products, options = {})
      @products = products
      @price_type = options[:price_type]
      @price_move = options[:price_move]
      @price_shift = options[:price_shift]
      @price_points = options[:price_points]
      @error_message = []
    end

    def call
      price_update
      if @error_message.size > 0
        [false, @error_message]
      else
        [true, I18n.t("we_update_price")]
      end
    end

  private

    def price_update
      @products.each do |product|
        salePrice = product.price.present? ? product.price : nil
        if @price_points == "fixed"
          if @price_move == "plus"
            new_price = (salePrice + @price_shift.to_f).round(-2)
          else
            new_price = (salePrice - @price_shift.to_f).round(-2)
          end
        else
          if @price_move == "plus"
            new_price = (salePrice + @price_shift.to_f*0.01*salePrice).round(-2)
          else
            new_price = (salePrice - @price_shift.to_f*0.01*salePrice).round(-2)
          end
        end
        product.update!(price: new_price) if new_price != nil
        @error_message << product.errors.full_messages if product.errors.present?
      end
    end

end