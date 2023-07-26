class Drop::Incase < Liquid::Drop

    def initialize(incase)
        @incase = incase
    end

    def do_work
        'do_work'
    end

    def region
        @incase.region
    end

    def strah
        @incase.strah.present? ? @incase.strah.short_title : ''
    end

    def stoanumber
        @incase.stoanumber
    end

    def unumber
        @incase.unumber
    end

    def company
        @incase.company.present? ? @incase.company.short_title : ''
    end

    def carnumber
        @incase.carnumber
    end

    def date
        @incase.date
    end

    def modelauto
        @incase.modelauto
    end

    def totalsum
        @incase.totalsum.to_i
    end

    def status
        @incase.incase_status.present? ? @incase.incase_status.title : ''
    end

    def tip
        @incase.tip.present? ? @incase.tip.title : ''
    end

    def line_items
        # @export.products.map(&:attributes)
        # products = @export.products.map(&:attributes)
        #.map{|line| {"id" => line.id, "sku" => line.sku, "price" => line.price, "quantity" => line.quantity, "title"=> line.title}}
        l_products = []
        @incase.incase_items.each do |li|
            b = li.attributes
            # b = pr.attributes
            # b['properties'] = pr.props.map{|l| [l.property.title,l.characteristic.title]}
            # host = Rails.env.development? ? 'http://localhost:3000' : 'http://95.163.236.170'
            # b['images'] = product.image_urls.map{|h| host+h[:url]}
            l_products.push(b)
        end
        # puts "l_products => "+l_products.to_s
        l_products
    end

end