class Drop::Export < Liquid::Drop

    def initialize(export)
        @export = export
    end

    def products
        puts "Drop::Export products start"
        # @export.products.map(&:attributes)
        # products = @export.products.map(&:attributes)
        #.map{|line| {"id" => line.id, "sku" => line.sku, "price" => line.price, "quantity" => line.quantity, "title"=> line.title}}
        l_products = []
        @export.products.each do |pr|
            b = pr.attributes
            b['properties'] = pr.props.map{|l| [l.property.title,l.characteristic.title]}
            host = Rails.env.development? ? 'http://localhost:3000' : 'http://95.163.236.170'
            # puts "product.image_urls.present? => "+product.image_urls.to_s
            # b['images'] = product.image_urls.present? ? product.image_urls.map{|h| host+h[:url]} : ''
            l_products.push(b)
        end
        # puts "l_products => "+l_products.to_s
        puts "l_products count => "+l_products.count.to_s
        puts "Drop::Export products end"
        l_products
    end

end