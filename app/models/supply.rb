# frozen_string_literal: true

# Supply < ApplicationRecord
class Supply < ApplicationRecord
  include NormalizeDataWhiteSpace
  audited
  belongs_to :supply_status
  belongs_to :company
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id'
  belongs_to :buyer, class_name: 'Company', foreign_key: 'buyer_id'
  has_many :supply_items, dependent: :destroy
  accepts_nested_attributes_for :supply_items, allow_destroy: true
  has_associated_audits
  after_initialize :add_title

  validates :supply_items, presence: true
  validates :title, presence: true

  after_create_commit { broadcast_prepend_to 'supplies_page1' }
  after_update_commit { broadcast_replace_to 'supplies' }
  after_destroy_commit { broadcast_remove_to 'supplies' }

  def self.ransackable_attributes(auth_object = nil)
    Supply.attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    %w[associated_audits audits company supply_items]
  end


  private

  def add_title
    self.title = 'Поступление'
  end

end
