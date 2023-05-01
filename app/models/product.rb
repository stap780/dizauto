class Product < ApplicationRecord
    include Rails.application.routes.url_helpers

    has_many :props
    has_many :properties, through: :props
    accepts_nested_attributes_for :props, allow_destroy: true
    has_rich_text :description
    has_many_attached :images, dependent: :destroy do |attachable|
        attachable.variant :thumb, resize_and_pad: [120, 120]
        attachable.variant :standart, resize_and_pad: [800, 800]
    end
    accepts_nested_attributes_for :images_attachments, allow_destroy: true
    before_save :normalize_data_white_space

    validates :title, presence: true


    def self.ransackable_attributes(auth_object = nil)
        Product.attribute_names
    end

    def properties_data
        self.props.map{|prop| { prop.property.title.to_s => prop.property.c_val(prop.characteristic_id).title.to_s } }
    end

    def images=(attachables)
        attachables = Array(attachables).compact_blank
        if attachables.any?
            attachment_changes["images"] =
            ActiveStorage::Attached::Changes::CreateMany.new("images", self, images.blobs + attachables)
        end
    end

    def image_urls
        return unless self.images.attached?
        self.images.map do |pr_image|
            pr_image.blob.attributes.slice('filename', 'byte_size', 'id').merge(url: pr_image_url(pr_image))
        end
    end

    def pr_image_url(image)
        rails_blob_path(image, only_path: true)
    end

    private
    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end


end
