class User < ApplicationRecord
  has_one_attached :avatar, dependent: :destroy
  after_initialize :set_default_role, if: :new_record?

  has_many :permissions, -> { order(pmodel: :asc) }
  accepts_nested_attributes_for :permissions, allow_destroy: true
  has_many :notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP

  Role = ["admin", "user", "driver"]

  def admin?
    role == "admin"
  end

  def self.ransackable_attributes(auth_object = nil)
    User.attribute_names
  end

  def set_default_role
    self.role ||= "user"
  end

  def self.admin_emails
    User.where(role: "admin").pluck(:email).join(",")
  end

  private 

  def valid_email?
    self.email =~ URI::MailTo::EMAIL_REGEXP
  end

end
