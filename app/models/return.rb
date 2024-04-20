class Return < ApplicationRecord
  audited
  belongs_to :client
  belongs_to :company, optional: true
  belongs_to :return_status
  belongs_to :invoice
  has_many :return_items, dependent: :destroy
  accepts_nested_attributes_for :return_items, allow_destroy: true
  after_destroy_commit { broadcast_remove_to "returns" }
  validates :quantity, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}

  def self.ransackable_attributes(auth_object = nil)
    Return.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

end
