# User < ApplicationRecord
class User < ApplicationRecord
  has_one_attached :avatar, dependent: :destroy
  after_initialize :set_default_role, if: :new_record?
  before_save :normalize_phone
  after_create :send_welcome_email

  has_many :permissions
  accepts_nested_attributes_for :permissions, allow_destroy: true
  has_many :notifications, as: :recipient, dependent: :destroy, class_name: 'Noticed::Notification'
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates :phone, phone: true, allow_blank: true

  ROLE = %w[admin user driver].freeze

  def admin?
    role == 'admin'
  end

  def self.ransackable_attributes(auth_object = nil)
    attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    %w[avatar_attachment avatar_blob notifications permissions]
  end

  def set_default_role
    self.role ||= 'user'
  end

  def self.admin_emails
    User.where(role: 'admin', notified: true).pluck(:email).join(',')
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  private

  def valid_email?
    self.email =~ URI::MailTo::EMAIL_REGEXP
  end

  def normalize_phone
    self.phone = Phonelib.parse(phone).full_e164.presence
  end

  def send_welcome_email
    email_data = {
      email_setup: EmailSetup.all.first,
      subject: 'Успешная регистрация на сайте',
      receiver: self
    }
    UserMailer.with(email_data).welcome_email.deliver_now
  end

end
