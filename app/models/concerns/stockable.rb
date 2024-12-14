# module Stockable
module Stockable
  extend ActiveSupport::Concern

  included do
    has_one :stock, as: :stockable
    accepts_nested_attributes_for :stock, allow_destroy: true

    def parent
      models = {
        enter_item: 'enter',
        incase_item: 'incas',
        invoice_item: 'invoice',
        loss_item: 'loss',
        location: 'placement',
        order_item: 'order',
        return_item: 'return',
        stock_transfer_item: 'stock_transfer',
        supply_item: 'supply'
      }
      search_model = models[self.model_name.i18n_key]
      puts "test => #{search_model}"
      search_model.singularize.classify.constantize.find(self["#{search_model}_id".to_sym])
    end
  end

end