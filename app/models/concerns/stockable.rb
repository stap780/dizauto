# module Stockable
module Stockable
  extend ActiveSupport::Concern

  included do
    has_one :stock, as: :stockable
    accepts_nested_attributes_for :stock, allow_destroy: true
    after_destroy_commit :remove_stock

    def parent
      models = {
        enter_item: 'enter',
        # incase_item: 'incase', # not use in stock business logic
        invoice_item: 'invoice',
        loss_item: 'loss',
        # location: 'placement', # not use in stock business logic
        # order_item: 'order', # not use in stock business logic
        return_item: 'return',
        # stock_transfer_item: 'stock_transfer', # not use in stock business logic
        supply_item: 'supply'
      }
      search_model = models[self.model_name.i18n_key]
      puts "test => #{search_model}"
      search_model.singularize.classify.constantize.find(self["#{search_model}_id".to_sym])
    end

    private

    def remove_stock
      self.stock.destroy
    end

  end

end