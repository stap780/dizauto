# Drop::Product < Liquid::Drop
class Drop::Product < Liquid::Drop

  def initialize(product)
    @product = product
  end

  def id
    @product.id
  end

  def title
    @product.title
  end

  def description
    @product.file_description
  end

  def video
    @product.video
  end

  def created_at
    @product.created_at
  end

  def updated_at
    @product.updated_at
  end

  def images
    # ['http://test.com/test.jpg','http://test.com/test1.jpg']
    @product.images_urls
  end

  def properties
    # [{title: 'test title', value: 'test value'}]
    @product.props_to_h.to_a
  end

  def variants
    @product.variants.map(&:attributes)
  end

end

# all methods above = Drop::Product.public_instance_methods - Liquid::Drop.public_instance_methods
