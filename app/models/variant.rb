class Variant < ApplicationRecord
  require "barby"
  require "barby/barcode/ean_13"
  require "barby/outputter/html_outputter"

  belongs_to :product
  has_many :incase_items
  has_many :incases, through: :incase_items
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :supply_items
  has_many :supplies, through: :supply_items
  has_many :stocks
  accepts_nested_attributes_for :stocks, allow_destroy: true
  has_many :locations, dependent: :destroy
  has_many :placements, through: :locations

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :barcode, length: { minimum: 3, maximum: 13 }, allow_blank: true
  validates :barcode, uniqueness: { allow_blank: true }

  after_initialize :set_default_new, if: :new_record?
  after_commit :create_barcode, on: :create
  before_destroy :check_relations_present, prepend: true

  attribute :title

  include ActionView::RecordIdentifier

  # scopes for slimselect
  scope :for_slimselect, -> { order(:id).limit(8) }
  scope :selected, ->(id) { where(id: id) }

  after_create_commit do 
    broadcast_append_to [product, :variants], target: dom_id(product, :variants), partial: "variants/variant", 
                                              locals: { product: product, variant: self  }
    # broadcast_update_to [detal, :detal_props], target: dom_id(detal, dom_id(DetalProp.new)), html: ''
  end

  after_update_commit do
    broadcast_replace_to [product, :variants], target: dom_id(product, dom_id(self)), partial: "variants/variant", 
                                                locals: { product: product, variant: self  }
  end

  after_destroy_commit do
    broadcast_remove_to [product, :variants], target: dom_id(product, dom_id(self))
  end

  def self.ransackable_attributes(auth_object = nil)
    Variant.attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    ["incase_items", "incases", "locations", "order_items", "orders", "placements", "product", "stocks", "supplies", "supply_items"]
  end

  def self.collection_for_select(id)
    collection = (selected(id) + for_slimselect).uniq
    collection.map { |var| [var.full_title, var.id] }
  end

  def create_barcode
    if !barcode.present?
      code_value = id.to_s.rjust(12, "0")
      barcode = Barby::EAN13.new(code_value)
      checksum = barcode.checksum
      update!(barcode: barcode.data_with_checksum)
    end
  end

  def html_barcode
    if barcode.size == 13
      barcode = Barby::EAN13.new(self.barcode[0...-1])
      barcode_for_html = Barby::HtmlOutputter.new(barcode)
      barcode_for_html.to_html.html_safe
    end
  end

  def full_title
    barcode.to_s + " - " + product.title.to_s + " - " + sku.to_s
  end

  def title
    self.product.title.to_s
  end


  private

  def set_default_new
    self.quantity = stocks.present? ? stocks.amount : 0
    self.price = 0 if price.nil?
  end

  def check_relations_present
    if locations.count > 0
      errors.add(:base, "Cannot delete product. You have #{I18n.t("locations")} with it.")
    end
    if order_items.count > 0
      errors.add(:base, "Cannot delete product. You have #{I18n.t("order_items")} with it.")
    end
    if incase_items.count > 0
      errors.add(:base, "Cannot delete product. You have #{I18n.t("incase_items")} with it.")
    end
    if supply_items.count > 0
      errors.add(:base, "Cannot delete product. You have #{I18n.t("supply_items")} with it.")
    end
    if errors.present?
      throw(:abort)
    end
  end

end
