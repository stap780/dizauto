class ProductContentSaveJob < ApplicationJob
  queue_as :product_content_save
  sidekiq_options retry: 0

  def perform(data)
    Product::ImportSaveData.call(data)
  end

end
