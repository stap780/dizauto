  class User < ApplicationRecord
    has_one_attached :avatar, dependent: :destroy
    after_initialize :set_default_role, :if => :new_record?

    has_many :permissions
    accepts_nested_attributes_for :permissions, allow_destroy: true, reject_if: :all_blank
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

    validates :name, presence: true
    
    Role = ['admin', 'user', 'driver']

    def admin?
      self.role == 'admin'
    end
    
    def self.ransackable_attributes(auth_object = nil)
      User.attribute_names
    end
  
    def set_default_role
      self.role ||= 'user'
    end

  end
  
  

