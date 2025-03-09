# frozen_string_literal: true

# Varbind < ApplicationRecord
class Varbind < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :variant
  belongs_to :varbindable, polymorphic: true

  validates :varbindable_id, presence: true, uniqueness: true
  validates :varbindable_type, presence: true
  validates :value, presence: true, uniqueness: true

  after_create_commit do 
    broadcast_append_to [variant.product, [variant, :varbinds]], target: dom_id(variant.product, dom_id(variant, :varbinds)), 
                                                         partial: 'varbinds/varbind',
                                                         locals: { product: variant.product, variant: variant, varbind: self }
  end

  after_update_commit do
    broadcast_replace_to [variant.product, [variant, :varbinds]], target: dom_id(variant.product, dom_id(variant, dom_id(self))), 
                                                          partial: 'varbinds/varbind',
                                                          locals: { product: variant.product, variant: variant, varbind: self }
  end

  after_destroy_commit do
    broadcast_remove_to [variant.product, [variant, :varbinds]], target: dom_id(variant.product, dom_id(variant, dom_id(self)))
  end

  def self.collections
    avitos = Avito.all.map { |a| ["Avito #{a.id}", a.id] }
    insales = Insale.all.map { |i| ["InSale #{i.id}", i.id] }
    avitos + insales
  end

end
