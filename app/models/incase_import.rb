class IncaseImport < ApplicationRecord
  has_one_attached :import_file, dependent: :destroy
  has_many :incase_import_columns, dependent: :destroy
  accepts_nested_attributes_for :incase_import_columns, allow_destroy: true

  validate :import_file_size

  scope :active, -> { where(active: true) }

  def self.ransackable_associations(auth_object = nil)
    ["incase_import_columns"]
  end

  def self.ransackable_attributes(auth_object = nil)
    IncaseImport.attribute_names
  end

  def self.import_attributes
    our_fields = {}
    not_use_incase_attr = ["id", "created_at", "updated_at", "incase_status_id", "incase_tip_id"]
    not_use_incase_item_attr = ["id", "created_at", "updated_at", "incase_id", "incase_item_status_id", "product_id"]

    # products = Spree::Product.attribute_names.map{|fi| [fi,'product#'+fi] if !not_use_product_attr.include?(fi)}+[['barcode','product#barcode'],['sku','product#sku'],['price','product#price'],['cat1','product#cat1'],['cat2','product#cat2'],['cat3','product#cat3'],['quantity','product#quantity'],['images','product#images'],['weight','product#weight'],['height','product#height'],['width','product#width'],['depth','product#depth']]
    # our_fields['product'] = products.reject(&:blank?)

    incases = Incase.attribute_names.map { |ot| [I18n.t("helpers.label.incase.#{ot}"), "incase#" + ot] if !not_use_incase_attr.include?(ot) }
    incase_items = IncaseItem.attribute_names.map { |ot| [I18n.t("helpers.label.incase_item.#{ot}"), "incase_item#" + ot] if !not_use_incase_item_attr.include?(ot) }
    our_fields["incases"] = incases.reject(&:blank?)
    our_fields["incase_items"] = incase_items.reject(&:blank?)
    # puts our_fields.to_s
    our_fields
  end

  def import_file_size
    return unless import_file.attached?

    unless import_file.blob.byte_size <= 10.megabyte
      errors.add(:import_file, "is too big")
    end

    acceptable_types = ["text/csv", "text/xls", "text/xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"]
    puts import_file.content_type
    unless acceptable_types.include?(import_file.content_type)
      errors.add(:import_file, "must be a CSV or XLS")
    end
  end
end
