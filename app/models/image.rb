class Image < ApplicationRecord
  include Rails.application.routes.url_helpers
  require "image_processing/vips"

  acts_as_list scope: :product, sequential_updates: false

  belongs_to :product
  has_one_attached :file do |attachable|
    # attachable.variant :sm, resize_to_limit: [120, 120]
    attachable.variant :thumb, resize_to_limit: [200, 200]
    attachable.variant :default, saver: {strip: true}
    # PNG is increase volume - only example
    # attachable.variant :def_png, saver: { strip: true, compression: 9 }, format: "png"
    # WEBP not use - only example
    # attachable.variant :def_webp, saver: { strip: true, quality: 75, lossless: false, alpha_q: 85, reduction_effort: 6, smart_subsample: true }, format: "webp"
  end
  validates :position, uniqueness: {scope: :product}

  validate :validate_image
  before_validation :set_position_if_nil, on: :create

  def self.ransackable_attributes(auth_object = nil)
    Image.attribute_names
  end

  private

  def validate_image
    return unless file.attached?

    unless file.blob.byte_size <= 10.megabyte
      errors.add(:file, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(file.content_type)
      errors.add(:file, "must be a JPEG or PNG")
    end
  end

  def set_position_if_nil
    return if position.present?
    last = Image.where(product_id: product.id).last
    self.position = last.present? ? last.position + 1 : 1
  end

  # This not use but it is work. I wrote this while search the solution to compress and upload to S3
  def compress_file
    if file.attached?
      blob = file.blob
      filename = blob.filename
      content_type = blob.content_type

      # This use when we save to S3
      file = blob.open do |tempfile|
        puts "compress_file ======= compress_file"
        puts "tempfile.path"
        puts tempfile.path
        ImageProcessing::MiniMagick.source(tempfile.path).saver!(quality: 80)
      end

      new_blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename)

      blob.attachments.any? ? blob.attachments.each { |attachment| attachment.purge } : blob.purge
      self.file.attach(new_blob.signed_id)
    end
  end
  
end
