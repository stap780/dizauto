class Loss < ApplicationRecord
  include NormalizeDataWhiteSpace
  audited
  belongs_to :loss_status
  belongs_to :warehouse
  belongs_to :stock_transfer, optional: true
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id'
  has_many :loss_items, dependent: :destroy
  accepts_nested_attributes_for :loss_items, allow_destroy: true
  has_associated_audits
  after_initialize :add_default

  validates :loss_items, presence: true
  validates :title, presence: true
  validates :date, presence: true

  def self.ransackable_attributes(auth_object = nil)
    Loss.attribute_names
  end
  
  def self.ransackable_associations(auth_object = nil)
    %w[associated_audits audits enter_items]
  end


  private

  def add_default
    self.title = "Списание"
    self.date = Time.now
  end

end
