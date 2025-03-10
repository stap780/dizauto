# Product < ApplicationRecord
class Product < ApplicationRecord
  require 'barby'
  require 'barby/barcode/ean_13'
  require 'barby/outputter/html_outputter'

  include NormalizeDataWhiteSpace
  include Rails.application.routes.url_helpers
  audited

  has_many :props, dependent: :destroy
  has_many :properties, through: :props
  accepts_nested_attributes_for :props, allow_destroy: true

  has_many :variants, -> { order(id: :asc) }, dependent: :destroy
  accepts_nested_attributes_for :variants, allow_destroy: true

  has_rich_text :description

  has_many :images, -> { order(position: :asc) }, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  has_associated_audits

  after_create_commit { broadcast_prepend_to 'products' }
  after_update_commit { broadcast_replace_to 'products' }
  after_destroy_commit { broadcast_remove_to 'products' }

  before_destroy :check_variants_have_relations, prepend: true

  validates :title, presence: true

  attribute :images_urls
  attribute :file_description

  scope :active, -> { where(status: 'active') }
  scope :draft, -> { where(status: 'draft') }
  scope :archived, -> { where(status: 'archived') }

  scope :tip_product, -> { where(tip: 'product') }
  scope :tip_service, -> { where(tip: 'service') }
  scope :tip_kit, -> { where(tip: 'ki') }

  scope :include_images, -> { includes(images: %i[file_attachment file_blob]) }
  scope :include_props, -> { includes(:props) }

  scope :all_quantity, -> { ransack(variants_quantity_gteq: 0).result }
  scope :no_quantity, -> { ransack(variants_quantity_lt: 1).result }
  scope :yes_quantity, -> { ransack(variants_quantity_gt: 0).result }
  scope :no_price, -> { ransack(variants_price_lt: 1).result }
  scope :yes_price, -> { ransack(variants_price_gt: 0).result }
  scope :with_images, -> { include_images.where.not(images: {product_id: nil}) }
  scope :without_images, -> { include_images.where(images: {product_id: nil}) }

  STATUS = %w[draft active archived].freeze
  TIP = %w[product service kit].freeze

  def self.ransackable_attributes(auth_object = nil)
    Product.attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    %w[associated_audits audits variants images locations properties props rich_text_description warehouses]
  end

  def self.ransackable_scopes(auth_object = nil)
    %i[no_quantity yes_quantity all_quantity no_price yes_price with_images without_images]
  end

  def next
    Product.where('id > ?', id).order(id: :asc).first || Product.first
  end

  def previous
    Product.where('id < ?', id).order(id: :desc).first || Product.last
  end

  def properties_data 
    # this is for export cvs/excel
    props.map { |prop| {prop.property.title.to_s => prop.characteristic.title.to_s} }
  end

  def props_to_h
    hash = {}
    props.each do |prop|
      hash[prop.property.title.to_s] = prop.characteristic.title.to_s
    end
    hash
  end

  def to_liquid
    @drop ||= Drop::Product.new(self)
  end

  def image_first
    return nil unless images.present?

    image = images.first
    (image.file.attached? && image.file_blob.service.exist?(image.file_blob.key)) ? image.file : nil
  end

  def image_urls
    host = Rails.env.development? ? 'http://localhost:3000' : 'https://erp.dizauto.ru'
    images.map do |image|
      host + rails_blob_path(image.file, only_path: true) if image.file.attached?
    end
  end

  # this is for attribute :images_urls
  def images_urls
    return [] unless images.present?

    images.map(&:s3_url)
  end

  # this is for attribute :file_description
  def file_description
    return '' unless description.present?

    description&.to_plain_text
  end

  def var_sku
    return '' unless variants.present?

    variants.first.sku
  end

  def var_barcode
    return '' unless variants.present?

    variants.first.barcode
  end

  def var_price
   return '' unless variants.present?

   variants.first.price
  end

  def self.import_from_file
    files = Product::SplitCsvFile.call
    files.each do |file|
      ProductImportCsvJob.perform_later(file)
    end
  end

  private

  def check_variants_have_relations
    if variants.size.positive?
      variants.each do |var|
        success, models = var.relation?
        if success
          models.each do |model|
            text = "Cannot delete. You have #{I18n.t(model)} with it."
            errors.add(:base, text)
          end
        end
      end
    end

    return unless errors.present?

    errors.add(:base, 'Cannot delete product')
    throw(:abort)
  end


end
