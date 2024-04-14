class Company < ApplicationRecord
  audited
  has_many :incases
  has_many :client_companies
  has_many :clients, through: :client_companies
  accepts_nested_attributes_for :client_companies, allow_destroy: true # , reject_if: proc { |attributes|  attributes['company_id'].blank? } # reject_if: :all_blank #,
  has_many :company_plan_dates
  accepts_nested_attributes_for :company_plan_dates, allow_destroy: true
  belongs_to :okrug

  # validates :title, presence: true
  validates :short_title, presence: true
  validates :short_title, uniqueness: true
  # validates :inn, presence: true
  # validates :inn, uniqueness: true
  # validates :client_companies, presence: true

  before_save :normalize_data_white_space
  before_destroy :check_relations_present, prepend: true


  scope :strah, -> { where(tip: "страховая") }
  scope :standart, -> { where(tip: "стандартная") }

  Company::TIP = ["стандартная", "страховая"].freeze

  def self.ransackable_attributes(auth_object = nil)
    Company.attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    ["audits", "incases", "client_companies"]
  end

  def emails
    clients.pluck(:email).join
  end

  def main_email
    # need create
    clients.first.email
  end

  def company_plan_dates_data
    (company_plan_dates.present? && company_plan_dates.last.date.present?) ?
                    company_plan_dates.last.date.strftime("%d/%m/%Y") + " " + company_plan_dates.last.comments.first.body : ""
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

  def check_relations_present
    if incases.count > 0
      errors.add(:base, "Cannot delete Company. You have #{I18n.t('incases')} with it.")
    end
    if clients.count > 0
      errors.add(:base, "Cannot delete Company. You have #{I18n.t('clients')} with it.")
    end
    if errors.present?
      throw(:abort)
    end
  end

end
