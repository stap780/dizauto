class ProductContentSaveJob < ApplicationJob
    queue_as :product_content_save


    def perform(pr_data)
        import_save = Product::ImportSaveData.new(pr_data)
        import_save.call
    end
  

end