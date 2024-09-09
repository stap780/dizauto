class ExportCreator < ApplicationService
  require "csv"
  require "caxlsx"

  attr_reader :export, :file_path

  def initialize(export, options = {})
    @export = export
    @options = options
    @host = Rails.env.development? ? "http://localhost:3000" : "https://erp.dizauto.ru"
    @file_name = "#{@export.id}.#{@export.format}"
    @file_path = "#{Rails.public_path}/#{@file_name}"
    @link = @host + "/" + @file_name
    @property_col_names = Property.order(:id).pluck(:title)
    @error_message = nil
  end

  def call
    puts "ExportCreator call"
    File.delete(@file_path) if File.file?(@file_path).present?
    result = create_csv if @export.format == "csv"
    result = create_xlsx if @export.format == "xlsx"
    result = create_xml if @export.format == "xml"
    puts "result => #{result}"
    if result == true
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
      # col_names_product_with_images = @export.excel_attributes.present? ? JSON.parse(@export.excel_attributes) + ["images"] : Product.column_names + ["images"]
      product_col_names = @export.excel_attributes.present? ? JSON.parse(@export.excel_attributes) : Product.attribute_names
      if @export.use_property == true
        # writer << col_names_product_with_images + @property_col_names
        writer << product_col_names + @property_col_names
      else
        # writer << col_names_product_with_images
        writer << product_col_names
      end
      @export.products.find_each(batch_size: 1000) do |product|
        # images = product.images.present? ? product.image_urls.join(" ") : " "
        # attr_for_sheet = product.attributes
        # attr_for_sheet["description"] = product.file_description
        # attr_for_sheet["images"] = images
        if @export.use_property == true
          prop_values_array = collect_property_values(product)
          # writer << attr_for_sheet.values_at(*col_names_product_with_images) + prop_values_array
          writer << product_col_names.map { |attr| product.send(attr) } + prop_values_array
        else
          # writer << attr_for_sheet.values_at(*col_names_product_with_images)
          writer << product_col_names.map { |attr| product.send(attr) }
        end
      end
    end
    puts "File.file?(@file_path).present? #{File.file?(@file_path).present?}"
    puts "end create_csv"
    return true if File.file?(@file_path).present?
    return false if !File.file?(@file_path).present?
  end

  def create_xlsx
    puts "create_xlsx => " + @export.inspect.to_s
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(name: "Sheet 1") do |sheet|
      product_col_names = @export.excel_attributes.present? ? JSON.parse(@export.excel_attributes) : Product.attribute_names
      if @export.use_property == true
        sheet.add_row product_col_names + @property_col_names
      else
        sheet.add_row product_col_names
      end
      @export.products.find_each(batch_size: 1000) do |product|
        if @export.use_property == true
          prop_values_array = collect_property_values(product)
          sheet.add_row product_col_names.map { |attr| product.send(attr) } + prop_values_array
        else
          sheet.add_row product_col_names.map { |attr| product.send(attr) }
        end
      end
    end
    stream = p.to_stream
    File.binwrite(@file_path, stream.read)
    return true if File.file?(@file_path).present?
    return false if !File.file?(@file_path).present?
  end

  def create_xml
    puts "create_xml => " + @export.inspect.to_s
    template = Liquid::Template.parse(@export.template)
    export_drop = Drop::Export.new(@export)
    xml = template.render("export" => export_drop)
    File.write(@file_path, xml)
    return true if File.file?(@file_path).present?
    return false if !File.file?(@file_path).present?
  end

  def collect_property_values(product)
    prop_values_array = []
    ppd = product.properties_data
    @property_col_names.each do |p_title|
      value = ppd.find { |a| a[p_title] }&.values&.uniq&.join
      value.present? ? prop_values_array.push(value) : prop_values_array.push("")
    end
    prop_values_array
  end

end
