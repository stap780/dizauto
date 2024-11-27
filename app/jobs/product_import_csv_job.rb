class ProductImportCsvJob < ApplicationJob
  queue_as :import_product

  def perform(file)
    # Rake::Task["transfer:product"].invoke(last_row)
    Product::ImportCsv.call(file)
  end
  
end
