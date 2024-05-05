class Place < ApplicationRecord
  belongs_to :warehouse

  validates :sector, presence: true
  validates :cell, presence: true

  def self.ransackable_attributes(auth_object = nil)
    Place.attribute_names
  end

  include ActionView::RecordIdentifier

  after_create_commit do 
    broadcast_append_to [warehouse, :places], target: dom_id(warehouse, :places), partial: "places/place", locals: { place: self, warehouse: warehouse  }
    broadcast_update_to [warehouse, :places], target: dom_id(warehouse, dom_id(Place.new)), html: ''
  end

  after_update_commit do
      broadcast_replace_to [warehouse, :places], target: dom_id(warehouse, dom_id(self)), partial: "places/place", locals: { place: self, warehouse: warehouse }
  end

  after_destroy_commit do
    broadcast_remove_to [warehouse, :places], target: dom_id(warehouse, dom_id(self))
  end

  def full_title
    self.sector.to_s+"//"+self.cell.to_s
  end

end
