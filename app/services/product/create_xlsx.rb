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
    # renderer = ActionController::Base.new
    # xlsx = renderer.render_to_string(layout: false, handlers: [:axlsx], formats: [:xlsx], template: @template, locals: {collection: @collection})
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(name: @model) do |sheet|
      sheet.add_row @attributes
      @collection.each do |item|
        sheet.add_row @attributes.map { |attr| item.send(attr) }
      end
    end

    # p.serialize 'basic_example.xlsx'
    stream = p.to_stream
    File.binwrite(@temp_file_path, stream.read)

  end

end