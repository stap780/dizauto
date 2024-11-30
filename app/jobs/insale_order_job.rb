class InsaleOrderJob < ApplicationJob
  queue_as :insale_order_import
  sidekiq_options retry: 0

  def perform(datas)
    Insale::Order.call(datas)
  end
  
end