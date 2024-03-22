class ProductImportJob < ApplicationJob
  queue_as :default

  def perform(file)
    # Rake::Task["transfer:product"].invoke(last_row)
    import = Product::ImportCsv.new(file)
    import.call
  end
end
