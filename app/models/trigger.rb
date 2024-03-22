class Trigger < ApplicationRecord
  has_many :actions
  accepts_nested_attributes_for :actions, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validates :event, presence: true
  validates :condition, presence: true
  before_save :normalize_data_white_space

  scope :active, -> { where(active: true).order(:id) }

  Event = [["Создание убытка", "create_incase", "incase"], ["Редактирование убытка", "update_incase", "incase"]].freeze

  def self.ransackable_attributes(auth_object = nil)
    Trigger.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end
end
