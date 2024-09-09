class Drop::Export < Liquid::Drop
  def initialize(export)
    @export = export
  end

  def products
    puts "Drop::Export products start"
    l_products = []
    @export.products.each do |product|
      b = product.attributes # this is Hash
      b["properties"] = product.props.map { |l| [l.property.title, l.characteristic.title] }
      b["images"] = product.images.present? ? product.images_urls : ""
      b["description"] = product.file_description
      l_products.push(b)
    end
    # puts "l_products => "+l_products.to_s
    puts "l_products count => " + l_products.count.to_s
    puts "Drop::Export products end"
    l_products
  end

end
