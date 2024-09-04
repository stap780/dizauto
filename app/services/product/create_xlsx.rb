class Product::CreateXlsx < ApplicationService
  require "caxlsx"

  def initialize(collection, options = {})
    @collection = collection
    @model = options[:model]
    @attributes = @model.camelize.constantize.attribute_names
    @filename = @model.downcase+".xlsx"
    @temp_file_path = Rails.env.development? ? "#{Rails.public_path}/#{@filename}" : "/var/www/dizauto/shared/public/#{@filename}"
    @error_message = []
  end

  def call
    File.delete(@temp_file_path) if File.file?(@temp_file_path).present?
    puts "Product::CreateXlsx call"
    file = create_file
    
    if @error_message.size == 0
      [true, @temp_file_path]
    else
      [false, @error_message]
    end

    # blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: @filename)
    # if blob
    #   [true, blob]
    # else
    #   [false, @error_message]
    # end
  end

  private

  def create_file
    puts "Product::CreateXlsx start create_file"
    # renderer = ActionController::Base.new
    # xlsx = renderer.render_to_string(layout: false, handlers: [:axlsx], formats: [:xlsx], template: @template, locals: {collection: @collection})
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(name: @model) do |sheet|
      sheet.add_row @attributes
      @collection.find_each(batch_size: 1000) do |item|
        puts "Product::CreateXlsx item => #{item.id}"
        sheet.add_row @attributes.map { |attr| item.send(attr) }
      end
    end
    puts "Product::CreateXlsx start stream = p.to_stream"
    stream = p.to_stream
    puts "Product::CreateXlsx end stream = p.to_stream"

    puts "Product::CreateXlsx start write file"
    file = File.binwrite(@temp_file_path, stream.read)
    puts "Product::CreateXlsx end write file"
    file
  end

end