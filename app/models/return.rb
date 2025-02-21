# Return < ApplicationRecord
class Return < ApplicationRecord
  include NormalizeDataWhiteSpace
  audited
  belongs_to :client
  belongs_to :company, optional: true
  belongs_to :return_status
  belongs_to :invoice
  has_many :return_items, dependent: :destroy
  accepts_nested_attributes_for :return_items, allow_destroy: true
  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'

  validates :return_items, presence: true
  after_save :set_return_number
  after_destroy_commit { broadcast_remove_to 'returns' }

  def self.ransackable_attributes(auth_object = nil)
    Return.attribute_names
  end

  private

  def set_return_number
    update_columns(number: self.id) if number.blank?
  end

end
