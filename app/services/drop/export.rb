class Drop::Export < Liquid::Drop

  def initialize(export)
    @export = export
  end

  def id
    @export.id
  end

  def products
    # puts "Drop::Export products start"
    l_products = []
    @export.products.find_each(batch_size: 1000) do |product|
      # puts "start b"
      b = product.attributes # this is Hash
      b['properties'] = collect_props(product)
      b['variants'] = product.variants.map{ |var| var.attributes }
      b['images'] = product.images_urls
      b['description'] = product.file_description
      l_products.push(b)
    end
    l_products
  end

  private

  def collect_props(product)
    return [] unless @export.use_property == true

    product.props_to_h.to_a
  end

end
