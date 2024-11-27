class ProductContentSaveJob < ApplicationJob
  queue_as :product_content_save
  sidekiq_options retry: 0

  def perform(pr_data)
    Product::ImportSaveData.call(pr_data)
  end

end
