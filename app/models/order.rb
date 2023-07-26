class Order < ApplicationRecord
    audited
    belongs_to :order_status
    belongs_to :payment_type
    belongs_to :delivery_type
    belongs_to :client
    belongs_to :manager, class_name: "User", foreign_key: "manager_id"
    has_many :order_items
    accepts_nested_attributes_for :order_items, reject_if: ->(attributes){ attributes['price'].blank? }, allow_destroy: true
    validates :order_status_id, presence: true
    validates :client_id, presence: true
    before_save :normalize_data_white_space

  

    def self.ransackable_attributes(auth_object = nil)
        Order.attribute_names
    end

    private


    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end


end
