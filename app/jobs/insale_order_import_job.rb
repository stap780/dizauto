# frozen_string_literal: true

# InsaleOrderImportJob
class InsaleOrderImportJob < ApplicationJob
  queue_as :insale_order_import
  sidekiq_options retry: 0

  def perform(datas)
    Insale::OrderImport.call(datas)
  end
end