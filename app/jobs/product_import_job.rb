class ProductImportJob < ApplicationJob
    queue_as :default

    def perform(last_row)
        Rake::Task["transfer:product"].invoke(last_row)
    end

end