class Product < ApplicationRecord
    has_many :prodprops, -> { order(id: :asc) }
    has_many :properties, through: :prodprops
    accepts_nested_attributes_for :prodprops, allow_destroy: true
    has_rich_text :description
    has_many_attached :images, dependent: :destroy do |attachable|
        attachable.variant :thumb, resize_and_pad: [120, 120]
        attachable.variant :standart, resize_and_pad: [800, 800]
    end
    accepts_nested_attributes_for :images_attachments, allow_destroy: true
    before_save :normalize_data_white_space

    validates :title, presence: true


    def self.ransackable_attributes(auth_object = nil)
        ["barcode", "costprice", "created_at", "description", "id", "price", "quantity", "sku", "title", "updated_at", "video"]
    end


    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end

    def images=(attachables)
        attachables = Array(attachables).compact_blank
        if attachables.any?
            attachment_changes["images"] =
            ActiveStorage::Attached::Changes::CreateMany.new("images", self, images.blobs + attachables)
        end
    end


end
