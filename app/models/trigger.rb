class Trigger < ApplicationRecord
  has_many :trigger_actions, dependent: :destroy
  accepts_nested_attributes_for :trigger_actions, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validates :event, presence: true
  validates :condition, presence: true
  before_save :normalize_data_white_space
  before_destroy :check_active, prepend: true

  scope :active, -> { where(active: true).order(:id) }

  Event = [ ["Создание убытка", "create_incase", "incase"], ["Редактирование убытка", "update_incase", "incase"],
            ["Создание заказа", "create_order", "order"], ["Редактирование заказа", "update_order", "order"],
            ["Создание позиции убытка", "create_incase_item", "incase_item"]].freeze

  def self.ransackable_attributes(auth_object = nil)
    Trigger.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

  def check_active
    if self.active
      errors.add(:base, "Cannot delete Trigger. it is active")
      throw(:abort)
    end
  end

end
