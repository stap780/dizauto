# frozen_string_literal: true

# Variant < ApplicationRecord
class Variant < ApplicationRecord
  require 'barby'
  require 'barby/barcode/ean_13'
  require 'barby/outputter/html_outputter'
  require 'barby/outputter/ascii_outputter'
  require 'barby/outputter/png_outputter'

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
    broadcast_append_to [product, :variants], target: dom_id(product, :variants), partial: 'variants/variant',
                                              locals: { product: product, variant: self }
    # broadcast_update_to [detal, :detal_props], target: dom_id(detal, dom_id(DetalProp.new)), html: ''
  end

  after_update_commit do
    broadcast_replace_to [product, :variants], target: dom_id(product, dom_id(self)), partial: 'variants/variant',
                                                locals: { product: product, variant: self }
  end

  after_destroy_commit do
    broadcast_remove_to [product, :variants], target: dom_id(product, dom_id(self))
  end

  def self.ransackable_attributes(auth_object = nil)
    attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    %w[incase_items incases locations order_items orders placements product stocks supplies supply_items]
  end

  def self.collection_for_select(id)
    collection = (selected(id) + for_slimselect).uniq
    collection.map { |var| [var.full_title, var.id] }
  end

  def create_barcode
    return if barcode.present?

    code_value = id.to_s.rjust(12, '0')
    barcode = Barby::EAN13.new(code_value)
    barcode.checksum
    update!(barcode: barcode.data_with_checksum)
  end

  def html_barcode
    return unless barcode&.size == 13

    barcode = Barby::EAN13.new(self.barcode[0...-1])
    barcode_for_html = Barby::HtmlOutputter.new(barcode)
    barcode_for_html.to_html.html_safe
  end

  def png_barcode
    return unless barcode&.size == 13

    barcode = Barby::EAN13.new(self.barcode[0...-1])
    barcode_png = Barby::PngOutputter.new(barcode)
    image_64 = barcode_png.to_png
    "<img src='data:image/png;base64,#{Base64.encode64(image_64)}'>".html_safe
  end

  def full_title
    "#{barcode} - #{product.title} - #{sku}"
  end

  def title
    product.title.to_s
  end

  def self.stocks_amount 
    # (lifehack) if we call from relation than we will get only relation data
    variants = Variant.all.order(created_at: :asc)
    qt = [0]
    variants.each do |variant|
      qt << variant.stocks.amount
    end
    qt.sum
  end

  def relation?
    result = []
    models = %w[locations order_items incase_items supply_items]
    models.each do |model|
      result << model if model.singularize.camelize.constantize.where(variant_id: id).present?
    end
    result.count.zero? ? [false, ''] : [true, result]
  end

  private

  def set_default_new
    self.quantity = stocks.present? ? stocks.amount : 0
    self.price = 0 if price.nil?
  end

  def check_relations_present
    success, models = relation?
    if success
      models.each do |model|
        text = "Cannot delete variant. You have #{I18n.t(model)} with it."
        errors.add(:base, text)
      end
    end
    throw(:abort) if errors.present?
  end

end
