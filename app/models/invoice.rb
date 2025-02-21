# Invoice < ApplicationRecord
class Invoice < ApplicationRecord
  include NormalizeDataWhiteSpace
  include AutomationProcess
  audited
  has_many :invoice_items, dependent: :destroy
  accepts_nested_attributes_for :invoice_items, allow_destroy: true
  belongs_to :company, optional: true
  belongs_to :client
  belongs_to :invoice_status
  belongs_to :order, optional: true # это убирает проверку presence: true , которая стоит по дефолту
  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'

  after_create_commit { broadcast_prepend_to 'invoices_page1' }
  after_update_commit { broadcast_replace_to 'invoices' }
  after_destroy_commit { broadcast_remove_to 'invoices'}

  after_save :set_invoice_number

  validates :invoice_items, presence: true

  def self.ransackable_attributes(auth_object = nil)
    attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    %w[associated_audits audits invoice_items]
  end

  private

  def set_invoice_number
    update_columns(number: self.id) if number.blank?
  end

end
