class User < ApplicationRecord
  has_one_attached :avatar, dependent: :destroy
  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?


  def self.ransackable_attributes(auth_object = nil)
    User.attribute_names
  end

  def set_default_role
    self.role ||= :user
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end

