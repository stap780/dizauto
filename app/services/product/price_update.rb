class Product::PriceUpdate < ApplicationService

    def initialize(products, options = {})
      @products = products
      @field_type = options[:field_type]
      @move = options[:move]
      @shift = options[:shift]
      @points = options[:points]
      @round = options[:round]
      @error_message = []
    end

    def call
      update
      if @error_message.size > 0
        [false, @error_message]
      else
        [true, I18n.t("we_update_price")]
      end
    end

  private

    def update
      @products.each do |product|
        product.variants.each do |variant|
          salePrice = variant.price.present? ? variant.price : nil
          puts "salePrice => #{salePrice}"
          puts "@shift => #{@shift}"
          if @points == "fixed"
            if @move == "plus"
              new_price = (salePrice + @shift.to_f).round(@round.to_i)
            else
              new_price = (salePrice - @shift.to_f).round(@round.to_i)
            end
          else
            if @move == "plus"
              new_price = (salePrice + @shift.to_f*0.01*salePrice).round(@round.to_i)
            else
              new_price = (salePrice - @shift.to_f*0.01*salePrice).round(@round.to_i)
            end
          end
          puts "new_price => #{new_price}"
          variant.update!(price: new_price) if new_price != nil
          @error_message << variant.errors.full_messages if variant.errors.present?
        end
      end
    end

end