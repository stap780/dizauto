# Place < ApplicationRecord
class Place < ApplicationRecord
  belongs_to :warehouse

  validates :sector, presence: true
  validates :cell, presence: true
  validates :cell, uniqueness: true
  validates :barcode, length: { minimum: 3, maximum: 13 }, allow_blank: true
  validates :barcode, uniqueness: { allow_blank: true }

  include ActionView::RecordIdentifier

  def self.ransackable_attributes(auth_object = nil)
    Place.attribute_names
  end

  after_create_commit do
    generate_barcode
    broadcast_append_to [warehouse, :places], target: dom_id(warehouse, :places), partial: 'places/place', locals: { place: self, warehouse: warehouse  }
    broadcast_update_to [warehouse, :places], target: dom_id(warehouse, dom_id(Place.new)), html: ''
  end

  after_update_commit do
    broadcast_replace_to [warehouse, :places], target: dom_id(warehouse, dom_id(self)), partial: 'places/place', locals: { place: self, warehouse: warehouse }
  end

  after_destroy_commit do
    broadcast_remove_to [warehouse, :places], target: dom_id(warehouse, dom_id(self))
  end

  def full_title
    "#{sector}//#{cell}"
  end

  private

  def generate_barcode
    self.barcode = "#{warehouse.id}#{id}".rjust(13, '0')
    save
  end

end
