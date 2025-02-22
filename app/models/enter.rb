# Enter < ApplicationRecord
class Enter < ApplicationRecord
  include NormalizeDataWhiteSpace
  audited
  belongs_to :enter_status
  belongs_to :warehouse
  belongs_to :stock_transfer, optional: true
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id'
  has_many :enter_items, dependent: :destroy
  accepts_nested_attributes_for :enter_items, allow_destroy: true
  has_associated_audits
  after_initialize :add_default

  validates :enter_items, presence: true
  validates :title, presence: true
  validates :date, presence: true

  def self.ransackable_attributes(auth_object = nil)
    Enter.attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    %w[associated_audits audits enter_items]
  end

  private

  def add_default
    self.title = 'Оприходование' if title.nil?
    self.date = Time.now if date.nil?
  end

end