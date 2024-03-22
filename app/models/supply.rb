class Supply < ApplicationRecord
  audited
  belongs_to :supply_status
  belongs_to :company
  belongs_to :manager, class_name: "User", foreign_key: "manager_id"
  has_many :supply_items, dependent: :destroy
  accepts_nested_attributes_for :supply_items, allow_destroy: true
  has_associated_audits
  after_initialize :add_title
  before_save :normalize_data_white_space

  validates :title, presence: true
  validates :supply_items, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["associated_audits", "audits", "company", "supply_items"]
  end

  def self.ransackable_attributes(auth_object = nil)
    Supply.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

  def add_title
    self.title = "Поступление"
  end
end
