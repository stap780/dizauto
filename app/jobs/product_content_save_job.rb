class ProductContentSaveJob < ApplicationJob
  queue_as :product_content_save
  sidekiq_options retry: 0

  def perform(pr_data)
    import_save = Product::ImportSaveData.new(pr_data)
    import_save.call
  end

end
