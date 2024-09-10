class Drop::Export < Liquid::Drop

  def initialize(export)
    @export = export
  end

  def products
    puts "Drop::Export products start"
    l_products = []
    @export.products.find_each(batch_size: 1000) do |product|
      puts "start b"
      b = product.attributes # this is Hash
      b["properties"] = product.props.map { |l| [l.property.title, l.characteristic.title] }
      b["images"] = product.images.present? ? product.images_urls.split(',') : ""
      b["description"] = product.file_description
      puts "collect b => #{b}"
      puts "end b"
      l_products.push(b)
    end
    puts "l_products count => #{l_products.count.to_s}"
    puts "Drop::Export products end"
    l_products
  end

end
