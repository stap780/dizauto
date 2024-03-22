class Drop::Product < Liquid::Drop
  def initialize(product)
    @product = product
  end

  def id
    @product.id
  end

  def sku
    @product.sku
  end

  def barcode
    @product.barcode
  end

  def barcode_as_img
    @product.html_barcode
  end

  def title
    @product.title
  end

  def description
    @product.description
  end

  def quantity
    @product.quantity
  end

  def costprice
    @product.costprice
  end

  def price
    @product.price
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
    @product.image_urls
  end

  def properties
    # [{title: 'test title', value: 'test value'}]
    @product.properties.map { |pr| pr.attributes }
  end
end
