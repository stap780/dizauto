class Drop::Export < Liquid::Drop

    def initialize(export)
        @export = export
    end

    def products
        # @export.products.map(&:attributes)
        # products = @export.products.map(&:attributes)
        #.map{|line| {"id" => line.id, "sku" => line.sku, "price" => line.price, "quantity" => line.quantity, "title"=> line.title}}
        l_products = []
        @export.products.each do |pr|
            b = pr.attributes
            b['properties'] = pr.prodprops.map{|l| [l.property.title,l.characteristic.title]}
            l_products.push(b)
        end
        # puts "l_products => "+l_products.to_s
        l_products
    end

end