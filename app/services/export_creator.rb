require 'csv'
require 'caxlsx'

class ExportCreator < ApplicationService
    attr_reader :export

    def initialize(export, options={})
        @export = export
        @options = options
    end

    def call
        puts 'ExportCreator call'
        create_csv if @export.format == 'csv'
        create_xlsx if @export.format == 'xlsx'
        create_xml if @export.format == 'xml'
    end
    
    def create_csv
        puts "create_csv => "+@export.inspect.to_s
        file_name = "#{@export.id.to_s}.csv"
        file_path = "#{Rails.public_path}/#{file_name}"
        File.delete(file_path) if File.file?(file_path).present?
        CSV.open( file_path, 'w') do |writer|
            col_names_product = @export.excel_attributes.present? ? JSON.parse(@export.excel_attributes) : Product.column_names
            if @export.use_property == true
                col_names_property = Property.order(:id).pluck(:title)
                writer << col_names_product+col_names_property
            else
                writer << col_names_product
            end
            @export.products.each do |product|
                if @export.use_property == true
                    prop_values_array = []
                    col_names_property.each do |p_title|
                        value = product.properties_data.map{|a| a[p_title]}.uniq.join
                        value.present? ? prop_values_array.push(value) : prop_values_array.push("")
                    end
                    writer << product.attributes.values_at(*col_names_product)+prop_values_array
                else
                    writer << product.attributes.values_at(*col_names_product)
                end    
            end
        end
        
        @export.link = file_name
        @export.save
    end

    def create_xlsx
        puts "create_xlsx => "+@export.inspect.to_s
        file_name = "#{@export.id.to_s}.xlsx"
        file_path = "#{Rails.public_path}/#{file_name}"
        File.delete(file_path) if File.file?(file_path).present?
        p = Axlsx::Package.new
        wb = p.workbook
        wb.add_worksheet(name: 'Sheet 1') do |sheet|
            col_names_product = @export.excel_attributes.present? ? JSON.parse(@export.excel_attributes) : Product.column_names
            if @export.use_property == true
                col_names_property = Property.order(:id).pluck(:title)
                sheet.add_row col_names_product+col_names_property
            else
                sheet.add_row col_names_product
            end
            @export.products.each do |product|
                if @export.use_property == true
                    prop_values_array = []
                    col_names_property.each do |p_title|
                        value = product.properties_data.map{|a| a[p_title]}.uniq.join
                        value.present? ? prop_values_array.push(value) : prop_values_array.push("")
                    end
                    sheet.add_row product.attributes.values_at(*col_names_product)+prop_values_array
                else
                    sheet.add_row product.attributes.values_at(*col_names_product)
                end    
            end
        end

        stream = p.to_stream
        File.open(file_path, 'wb') { |f| f.write(stream.read) }

        @export.link = file_name
        @export.save
    end

    def create_xml
        file_name = "#{@export.id.to_s}.xml"
        file_path = "#{Rails.public_path}/#{file_name}"
        File.delete(file_path) if File.file?(file_path).present?
        puts "create_xml => "+@export.inspect.to_s
        template = Liquid::Template.parse(@export.template)
        export_drop = Drop::Export.new(@export)
        xml = template.render('export' => export_drop)
        File.open(file_path, "w") {|f| f.write(xml)}
        @export.link = file_name
        @export.save
    end

end