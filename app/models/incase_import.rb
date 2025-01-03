class IncaseImport < ApplicationRecord
  has_one_attached :file, dependent: :destroy
  has_many :incase_import_columns, dependent: :destroy
  accepts_nested_attributes_for :incase_import_columns, allow_destroy: true

  validate :file_size
  after_create_commit { broadcast_prepend_to 'incase_imports' }

  scope :active, -> { where(active: true) }

  def self.ransackable_attributes(auth_object = nil)
    IncaseImport.attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    ['incase_import_columns']
  end


  def self.import_attributes
    our_fields = {}
    not_use_incase_attr = %w[id created_at updated_at incase_status_id incase_tip_id]
    not_use_incase_item_attr = %w[id created_at updated_at incase_id incase_item_status_id variant_id vat]

    incase_attr = Incase.attribute_names.map { |ot| [I18n.t("helpers.label.incase.#{ot}"), "incase#" + ot] if !not_use_incase_attr.include?(ot) }
    incase_item_attr = IncaseItem.attribute_names.map { |ot| [I18n.t("helpers.label.incase_item.#{ot}"), "incase_item#" + ot] if !not_use_incase_item_attr.include?(ot) }
    our_fields[I18n.t('helpers.label.incase_import.incase')] = incase_attr.reject(&:blank?)
    our_fields[I18n.t('helpers.label.incase_import.incase_item')] = incase_item_attr.reject(&:blank?)
    our_fields
  end

  def file_size
    return unless file.attached?

    unless file.blob.byte_size <= 10.megabyte
      errors.add(:file, 'is too big')
    end

    acceptable_types = ['text/csv', 'text/xls', 'text/xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/vnd.ms-excel']
    puts file.content_type
    unless acceptable_types.include?(file.content_type)
      errors.add(:file, 'must be a CSV or XLS')
    end
  end
  
end
