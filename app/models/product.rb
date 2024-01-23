class Product < ApplicationRecord
	require 'barby'
	require 'barby/barcode/ean_13'
	require 'barby/outputter/html_outputter'
    
    include Rails.application.routes.url_helpers
    audited

    has_many :props
    has_many :properties, through: :props
    accepts_nested_attributes_for :props, allow_destroy: true
    has_many :places
    has_many :warehouses, through: :places
    accepts_nested_attributes_for :places, allow_destroy: true
    
    has_rich_text :description
    # has_many_attached :images, dependent: :destroy do |attachable|
    #     attachable.variant :thumb, resize_and_pad: [110, 110]
    #     attachable.variant :standart, resize_and_pad: [800, 800]
    # end
    # accepts_nested_attributes_for :images_attachments, allow_destroy: true


    has_many :images, -> { order(position: :asc) }, dependent: :destroy
    accepts_nested_attributes_for :images, allow_destroy: true


    has_associated_audits
    after_initialize :set_default_new
    before_save :normalize_data_white_space
    after_commit :create_barcode, on: :create


    validates :title, presence: true
    validates :quantity, presence: true
    validates :price, presence: true
    validates :barcode, length: {minimum: 5, maximum: 13}, allow_blank: true


    def self.ransackable_attributes(auth_object = nil)
        Product.attribute_names
    end
    
    def self.ransackable_associations(auth_object = nil)
        ["associated_audits", "audits", "images_attachments", "images_blobs", "places", "properties", "props", "rich_text_description", "warehouses"]
    end

	def self.ransackable_scopes(auth_object = nil)
		[:no_quantity, :yes_quantity, :all_quantity, :no_price, :yes_price]
	end

    def self.all_quantity
        ransack(quantity__gteq: 0).result
    end
	
    def self.no_quantity
		ransack(quantity_lt: 1).result
	end
 
	def self.yes_quantity
		ransack(quantity_gt: 0).result
	end

    def self.no_price
		ransack(price_lt: 1).result
	end
 
	def self.yes_price
		ransack(price_gt: 0).result
	end

    def full_title
        self.barcode.to_s+" - "+self.title.to_s+" - "+self.sku.to_s
    end
    
    def properties_data # this for export cvs/excel
        #self.props.map{|prop| { prop.property.title.to_s => prop.property.c_val(prop.characteristic_id).title.to_s } }
        self.props.map{|prop| { prop.property.title.to_s => prop.property.characteristic.title.to_s } }
    end

    def image_first
        return unless self.images.present?
        image = self.images.first
        image.file.attached? ? image.file : nil
    end

    # def images=(attachables) # this need for save images that we already have when add one more image/images
    #     attachables = Array(attachables).compact_blank
    #     if attachables.any?
    #         # attachables is a [] - array of - signed_id attribute of an ActiveStorage Blob is a unique identifier for the blob that is signed with a secret key 
    #         # images.blobs - ActiveRecord::Associations of blobs - [#<ActiveStorage::Blob id: 3096, key: "18cnq9layi3zrs588ft075pmmqyv", filename: "0000000220989_1.jpg", content_type: "image/jpeg", metadata: {"identified"=>true, "width"=>1200, "height"=>900, "analyzed"=>true}, service_name: "local", byte_size: 170385, checksum: "nNvp7v7q48TdeT8cXS7mpA==", created_at: "2023-12-29 19:05:39.912817000 +0300">, #<ActiveStorage::Blob id: 3097, key: "slr85230tkamaui0izkv8u4rdon9", filename: "0000000220989_2.jpg", content_type: "image/jpeg", metadata: {"identified"=>true, "width"=>1200, "height"=>900, "analyzed"=>true}, service_name: "local", byte_size: 129859, checksum: "NEEEmQ0PFrXU5nK/d5Iijw==", created_at: "2023-12-29 19:05:41.202385000 +0300">, #<ActiveStorage::Blob id: 3098, key: "6om7ypyrbnph97kt246947808j5f", filename: "0000000220989_3.jpg", content_type: "image/jpeg", metadata: {"identified"=>true, "width"=>1200, "height"=>900, "analyzed"=>true}, service_name: "local", byte_size: 142027, checksum: "laGvKumrpACj5yZr1EKy/g==", created_at: "2023-12-29 19:05:42.170116000 +0300">]
    #         puts "images.blobs"
    #         puts images.blobs.map{|blob| blob}.to_s
    #         puts "attachables"
    #         puts attachables.to_s
    #         attachables.each do |signed_id|
    #             blob = ActiveStorage::Blob.find_signed(signed_id)
    #             puts blob.to_s
    #         end
    #         # puts images.blobs.inspect!
    
    #         attachment_changes["images"] = ActiveStorage::Attached::Changes::CreateMany.new("images", self, images.blobs + attachables)
    #     end
    # end

    # def image_urls #old for images attached (active storage)
    #     return unless self.images.attached?
    #     self.images.map do |pr_image|
    #         pr_image.blob.attributes.slice('filename', 'byte_size', 'id').merge(url: pr_image_url(pr_image))
    #     end
    # end

    # def pr_image_url(image)
    #     rails_blob_path(image, only_path: true)
    # end

    def image_urls
        host = Rails.env.development? ? 'http://localhost:3000' : 'https://erp.dizauto.ru'
        self.images.map do |image|
            host+rails_blob_path(image.file, only_path: true) if image.file.attached? 
        end
    end
    
    def create_barcode
        if !self.barcode.present?
            code_value = self.id.to_s.rjust(12, "0")
            barcode = Barby::EAN13.new(code_value)
            checksum = barcode.checksum
            self.update!(barcode: barcode.data_with_checksum)
        end
    end

    def html_barcode
        if self.barcode.size == 13
            barcode = Barby::EAN13.new(self.barcode[0...-1])
            barcode_for_html = Barby::HtmlOutputter.new(barcode)
            barcode_for_html.to_html.html_safe
        end
    end
    
    # def add_check_digit(code_value) 
    #     sum = 0
    #     code_value.to_s.split(//).each_with_index{|i,index| sum = sum + (i[0].to_i * ((index+1).even? ? 3 : 1))}
    #     check_digit = sum.zero? ? 0 : (10-(sum % 10))
    #     return (code_value.to_s.split(//)<<check_digit).join("")
    # end

    def self.import_product_from_file #(last_row)
        ProductImportJob.perform_later #(last_row)
    end


    private

    
    def set_default_new
        # self.quantity = 0 if new_record?
        # self.price = 0 if new_record?
    end
    
    def normalize_data_white_space
        self.attributes.each do |key, value|
            self[key] = value.squish if value.respond_to?("squish")
        end
    end

end
