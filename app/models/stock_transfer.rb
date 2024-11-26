class StockTransfer < ApplicationRecord
  audited
  belongs_to :stock_transfer_status
  belongs_to :origin_warehouse, class_name: 'Warehouse', foreign_key: 'origin_warehouse_id'
  belongs_to :destination_warehouse, class_name: 'Warehouse', foreign_key: 'destination_warehouse_id'
  has_many :stock_transfer_items, dependent: :destroy
  accepts_nested_attributes_for :stock_transfer_items, allow_destroy: true
  has_associated_audits
  has_many :enters, dependent: :destroy
  has_many :losses, dependent: :destroy
  before_destroy :check_associations, prepend: true
  validates :stock_transfer_items, presence: true

  def self.ransackable_attributes(auth_object = nil)
    StockTransfer.attribute_names
  end
  
  def self.ransackable_associations(auth_object = nil)
    %w[associated_audits audits stock_transfer_items]
  end


  def check_associations
    if enters.count > 0
      errors.add(:base, "Cannot delete Stock Transfer. You have enters with it.")
      throw(:abort)
    end
    if losses.count > 0
      errors.add(:base, "Cannot delete Stock Transfer. You have losses with it.")
      throw(:abort)
    end
  end

end
