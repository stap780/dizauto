class Drop::Incase < Liquid::Drop

    def initialize(incase)
        @incase = incase
    end

    def do_work #this is for check condition true/false
        'do_work'
    end

    def id
        @incase.id
    end

    def region
        @incase.region
    end

    def strah
        # @incase.strah.present? ? @incase.strah.short_title : ''
        @incase.strah.present? ? @incase.strah.attributes : []
    end

    def stoanumber
        @incase.stoanumber
    end

    def unumber
        @incase.unumber
    end

    def unumber_uniq?
        Incase.where(unumber: @incase.unumber).size == 1 ? true : false
    end

    def unumber_not_uniq?
        Incase.where(unumber: @incase.unumber).size == 1 ? false : true
    end

    def company
        # @incase.company.present? ? @incase.company.short_title : ''
        @incase.company.present? ? @incase.company.attributes : []
    end

    def company_clients
        @incase.company.present? ? @incase.company.clients.map{|cl| cl.attributes} : []
    end

    def company_comment
        # @incase.company.present? ? @incase.company.short_title : ''
        @incase.company.present? && @incase.company.comments.present?  ? @incase.company.comments.first.body : ''
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
        @incase.incase_tip_id.present? ? @incase.incase_tip.title : ''
    end

    def items
        # @export.products.map(&:attributes)
        # products = @export.products.map(&:attributes)
        #.map{|line| {"id" => line.id, "sku" => line.sku, "price" => line.price, "quantity" => line.quantity, "title"=> line.title}}
        # l_products = []
        # @incase.incase_items.each do |li|
        #     b = li.attributes
            ## b = pr.attributes
            ## b['properties'] = pr.props.map{|l| [l.property.title,l.characteristic.title]}
            ## host = Rails.env.development? ? 'http://localhost:3000' : 'http://95.163.236.170'
            ## b['images'] = product.image_urls.map{|h| host+h[:url]}
        #     l_products.push(b)
        # end
        # puts "l_products => "+l_products.to_s
        # l_products
        @incase.incase_items.present? ? @incase.incase_items.map{|li| li.attributes} : []
    end

    def items_statuses
        @incase.incase_items.map{|i_i| i_i.incase_item_status.title}
    end

end