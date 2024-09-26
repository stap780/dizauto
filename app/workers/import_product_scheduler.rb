require "sidekiq-scheduler"

class ImportProductScheduler
  include Sidekiq::Worker

  def perform
    Product.import_from_file
  end

end
