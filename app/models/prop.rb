class Prop < ApplicationRecord
  belongs_to :property
  belongs_to :characteristic
  belongs_to :product

  default_scope -> { order(id: :asc) }

  validates :characteristic_id, uniqueness: {scope: [:property, :product]}

  include ActionView::RecordIdentifier

  after_create_commit do 
    broadcast_append_to [product, :props], target: dom_id(product, :props), partial: "props/prop", locals: { prop: self, product: product  }
    broadcast_update_to [product, :props], target: dom_id(product, dom_id(Prop.new)), html: ''
  end

  after_update_commit do
      broadcast_replace_to [product, :props], target: dom_id(product, dom_id(self)), partial: "props/prop", locals: { prop: self, product: product }
  end

  after_destroy_commit do
    broadcast_remove_to [product, :props], target: dom_id(product, dom_id(self))
  end

end
