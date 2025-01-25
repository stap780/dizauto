# class Client < ApplicationRecord
class Client < ApplicationRecord
  has_many :client_companies
  has_many :companies, through: :client_companies
  has_many :orders
  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true

  before_save :normalize_data_white_space
  before_destroy :check_relations_present, prepend: true

  include ActionView::RecordIdentifier

  after_create_commit { broadcast_append_to 'clients' }
  after_update_commit { broadcast_replace_to 'clients' }
  after_destroy_commit { broadcast_remove_to 'clients' }


  scope :first_five, -> { all.limit(5).map { |p| [p.full_name, p.id] } }
  scope :collection_for_select, ->(id) { where(id: id).map { |p| [p.full_name, p.id] } + first_five }

  def full_name
    [name, surname, email].join('')
  end

  def self.ransackable_attributes(auth_object = nil)
    Client.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

  def check_relations_present
    if orders.count.positive?
      errors.add(:base, "Cannot delete Client. You have #{I18n.t('orders')} with it.")
    end
    if companies.count.positive?
      errors.add(:base, "Cannot delete Client. You have #{I18n.t('companies')} with it.")
    end

    throw(:abort) if errors.present?
  end

end
