class Image < ApplicationRecord
    acts_as_list scope: :product, sequential_updates: false
  
    belongs_to :product
    has_one_attached :file, dependent: :destroy  do |attachable|
        attachable.variant :thumb, resize_to_limit: [100, 100]
    end
    validates :position, uniqueness: { scope: :product }

    validate :validate_image
    before_validation :set_position_if_nil, on: :create

    

    private

    def validate_image
        return unless file.attached?
      
        unless file.blob.byte_size <= 10.megabyte
          errors.add(:main_image, "is too big")
        end
      
        acceptable_types = ["image/jpeg", "image/png"]
        unless acceptable_types.include?(file.content_type)
          errors.add(:file, "must be a JPEG or PNG")
        end
    end

    def set_position_if_nil
      return unless self.position.present?
      self.position = self.product.images.present? ? self.product.images.last.position + 1 : 1
    end

end
