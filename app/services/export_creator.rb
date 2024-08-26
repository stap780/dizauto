require "csv"
require "caxlsx"

class ExportCreator < ApplicationService
  attr_reader :export

  def initialize(export_id, options = {})
    @export = Export.find_by_id(export_id)
    @options = options
    @host = Rails.env.development? ? "http://localhost:3000" : "https://erp.dizauto.ru"
    @file_name = "#{@export.id}.#{@export.format}"
    @file_path = "#{Rails.public_path}/#{@file_name}"
    @link = @host + "/" + @file_name
    @col_names_property = Property.order(:id).pluck(:title)
    @error_message = nil
  end

  def call
    puts "ExportCreator call"
    File.delete(@file_path) if File.file?(@file_path).present?
    result = create_csv if @export.format == "csv"
    result = create_xlsx if @export.format == "xlsx"
    result = create_xml if @export.format == "xml"
    if result
      @export.update(link: @link, status: 'finish')
      [true, @export]
    else
      @export.update(link: @link, status: 'error')
      [false, @error_message]
    end
  end

  private

  def create_csv
    puts "create_csv => " + @export.inspect.to_s
    CSV.open(@file_path, "w") do |writer|
      col_names_product_with_images = @export.excel_attributes.present? ? JSON.parse(@export.excel_attributes) + ["images"] : Product.column_names + ["images"]
      if @export.use_property == true
        writer << col_names_product_with_images + @col_names_property
      else
        writer << col_names_product_with_images
      end
      @export.products.find_each do |product|
        images = product.images.present? ? product.image_urls.join(" ") : " "
        attr_for_sheet = product.attributes
        attr_for_sheet["images"] = images
        if @export.use_property == true
          prop_values_array = []
          @col_names_property.each do |p_title|
            value = product.properties_data.map { |a| a[p_title] }.uniq.join
            value.present? ? prop_values_array.push(value) : prop_values_array.push("")
          end
          writer << attr_for_sheet.values_at(*col_names_product_with_images) + prop_values_array
        else
          writer << attr_for_sheet.values_at(*col_names_product_with_images)
        end
      end
    end
  end

  def create_xlsx
    puts "create_xlsx => " + @export.inspect.to_s
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(name: "Sheet 1") do |sheet|
      col_names_product_with_images = @export.excel_attributes.present? ? JSON.parse(@export.excel_attributes) + ["images"] : Product.column_names + ["images"]
      if @export.use_property == true
        sheet.add_row col_names_product_with_images + @col_names_property
      else
        sheet.add_row col_names_product
      end
      @export.products.find_each do |product|
        images = product.images.present? ? product.image_urls.join(" ") : " "
        puts "images => " + images
        attr_for_sheet = product.attributes
        attr_for_sheet["images"] = images
        if @export.use_property == true
          prop_values_array = []
          @col_names_property.each do |p_title|
            value = product.properties_data.map { |a| a[p_title] }.uniq.join
            value.present? ? prop_values_array.push(value) : prop_values_array.push("")
          end
          sheet.add_row attr_for_sheet.values_at(*col_names_product_with_images) + prop_values_array
        else
          sheet.add_row attr_for_sheet.values_at(*col_names_product_with_images)
        end
      end
    end
    stream = p.to_stream
    File.binwrite(@file_path, stream.read)
  end

  def create_xml
    puts "create_xml => " + @export.inspect.to_s
    template = Liquid::Template.parse(@export.template)
    export_drop = Drop::Export.new(@export)
    xml = template.render("export" => export_drop)
    File.write(@file_path, xml)
  end

end
