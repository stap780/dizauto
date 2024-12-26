class ProductImageJob < ApplicationJob
  queue_as :attach_image

  def perform(product, images)
    Product::ImportImage.call(product, images)
  end
end
