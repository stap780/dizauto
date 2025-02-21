# Company < ApplicationRecord
class Company < ApplicationRecord
  include NormalizeDataWhiteSpace
  audited
  has_many :incases
  has_many :client_companies
  has_many :clients, through: :client_companies
  accepts_nested_attributes_for :client_companies, allow_destroy: true
  has_many :company_plan_dates
  accepts_nested_attributes_for :company_plan_dates, allow_destroy: true
  belongs_to :okrug

  validates :short_title, presence: true
  validates :short_title, uniqueness: true

  before_destroy :check_relations_present, prepend: true

  scope :our, -> { where(tip: 'our') }
  scope :strah, -> { where(tip: 'strah') }
  scope :standart, -> { where(tip: 'standart') }

  TIP = %w[standart strah our].freeze

  def self.ransackable_attributes(auth_object = nil)
    attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    %w[audits incases client_companies company_plan_dates]
  end

  def emails
    clients.pluck(:email).join
  end

  def main_email
    # need create
    clients.first.email
  end

  def company_plan_dates_data

    return '' unless company_plan_dates.present? && company_plan_dates.last.date.present?

    "#{company_plan_dates.last.date.strftime('%d/%m/%Y')} #{company_plan_dates.last.comments.first.body}"
  end

  def self.tip_collection
    TIP.map { |key| [I18n.t(key, scope: %i[company tip]), key] }
  end

  private

  def check_relations_present
    if incases.count.positive?
      errors.add(:base, "Cannot delete Company. You have #{I18n.t('incases')} with it.")
    end
    if clients.count.positive?
      errors.add(:base, "Cannot delete Company. You have #{I18n.t('clients')} with it.")
    end

    throw(:abort) if errors.present?
  end

end
