class ExportCreator < ApplicationService
  require "csv"
  require "caxlsx"

  attr_reader :export, :file_path

  def initialize( export, options = {} )
    @export = export
    @options = options
    @host = Rails.env.development? ? 'http://localhost:3000' : 'https://erp.dizauto.ru'
    @file_name = "#{@export.id}.#{@export.format}"
    @file_path = "#{Rails.public_path}/#{@file_name}"
    @link = [@host, @file_name].join('/')
    @pr_attributes = Product.attribute_names - ['description']
    @var_attributes = Variant.attribute_names - %w[id product_id created_at updated_at title]
    @all_attributes = @pr_attributes + @var_attributes
    @property_col_names = Property.order(:id).pluck(:title)
    @error_message = nil
  end

  def call
    delete_file
    result = create_csv if @export.format == 'csv'
    result = create_xlsx if @export.format == 'xlsx'
    result = create_xml if @export.format == 'xml'
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
    CSV.open(@file_path, 'w') do |writer|
      file_headers = collect_header
      writer << file_headers
      @export.products.find_each(batch_size: 1000) do |product|
        data = {}
        file_headers.each{ |i| data[i] = '' }
        props_data = product.props_to_h
        product.variants.each do |variant|
          file_headers.each do |attr|
            data[attr] = product.send(attr) if product.respond_to?(attr) # we use SEND because have virtual attr
            data[attr] = variant[attr] unless data[attr].present?
            data[attr] = props_data[attr] unless data[attr].present?
          end
          writer << data.values
        end
      end
    end
    we_have_file?
  end

  def create_xlsx
    # puts "create_xlsx => " + @export.inspect.to_s
    p = Axlsx::Package.new
    wb = p.workbook
    check_int = %w[id price quantity cost_price]
    wb.add_worksheet(name: 'Sheet 1') do |sheet|
      file_headers = collect_header
      sheet.add_row file_headers
      types = file_headers.map{ |attr| check_int.include?(attr) ? 'integer'.to_sym : 'string'.to_sym}
      @export.products.find_each(batch_size: 1000) do |product|
        data = {}
        file_headers.each{ |i| data[i] = '' }
        props_data = product.props_to_h
        product.variants.each do |variant|
          file_headers.each do |attr|
            data[attr] = product.send(attr) if product.respond_to?(attr) # we use SEND because have virtual attr
            data[attr] = variant[attr] unless data[attr].present?
            data[attr] = props_data[attr] unless data[attr].present?
          end
          sheet.add_row data.values, types: types
        end
      end
    end
    stream = p.to_stream
    File.binwrite(@file_path, stream.read)
    we_have_file?
  end

  def create_xml
    template = Liquid::Template.parse(@export.template)
    export_drop = Drop::Export.new(@export)
    xml = template.render('export' => export_drop)
    File.write(@file_path, xml)
    we_have_file?
  end

  def delete_file
    File.delete(@file_path) if File.file?(@file_path).present?
  end

  def we_have_file?
    File.file?(@file_path).present?
  end

  def collect_header
    product_col_names = @export.excel_attributes.present? ? JSON.parse(@export.excel_attributes) : @all_attributes
    @export.use_property == true ? (product_col_names + @property_col_names) : product_col_names
  end

end
