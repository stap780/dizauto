class DetalProp < ApplicationRecord
  belongs_to :property
  belongs_to :characteristic
  belongs_to :detal

  default_scope -> { order(id: :asc) }

  validates :characteristic_id, uniqueness: {scope: [:property, :detal]}
  
  include ActionView::RecordIdentifier

  after_create_commit do 
    broadcast_append_to [detal, :detal_props], target: dom_id(detal, :detal_props), partial: "detal_props/detal_prop", locals: { prop: self, detal: detal  }
    broadcast_update_to [detal, :detal_props], target: dom_id(detal, dom_id(DetalProp.new)), html: ''
  end

  after_update_commit do
      broadcast_replace_to [detal, :detal_props], target: dom_id(detal, dom_id(self)), partial: "detal_props/detal_prop", locals: { prop: self, detal: detal }
  end

  after_destroy_commit do
    broadcast_remove_to [detal, :detal_props], target: dom_id(detal, dom_id(self))
  end

end
