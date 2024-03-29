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
end
