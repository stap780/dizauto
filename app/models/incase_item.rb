# frozen_string_literal: true

# IncaseItem < ApplicationRecord
class IncaseItem < ApplicationRecord
  include AutomationProcess
  audited associated_with: :incase
  belongs_to :incase
  belongs_to :incase_item_status, optional: true # это убирает проверку presence: true , которая стоит по дефолту
  belongs_to :variant, optional: true

  validates :title, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_initialize :set_default_new
  before_save :normalize_data_white_space
  before_create :create_product_variant


  def self.ransackable_attributes(auth_object = nil)
    IncaseItem.attribute_names
  end

  private

  def set_default_new
    self.quantity = 0 if quantity.nil?
  end

  def create_product_variant
    product = Product.create!(
      title: self.title ||= 'Incase product',
      status: 'draft',
      tip: 'product'
    )
    variant = product.variants.create!(
      quantity: self.quantity ||= 0,
      price: self.price ||= 0
      )
    self.variant_id = variant.id
  end

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

end