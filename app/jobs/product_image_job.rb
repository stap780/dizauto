class ProductImageJob < ApplicationJob
  queue_as :attach_image

  def perform(product, images)
    Product::ImportImage.new(product, images).call
  end
end
