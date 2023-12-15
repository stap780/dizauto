class Incase::Import
    require 'open-uri'

    attr_accessor :incase_import, :columns, :header, :file_data, :import_data, :check_message

    def initialize(incase_import)
        puts "IncaseImport::Import initialize"
        @incase_import = incase_import
        @columns = @incase_import.incase_import_columns
        # file = Rails.application.routes.url_helpers.url_for(incase_import.import_file)
        # file = ActiveStorage::Blob.service.path_for(incase_import.import_file.key)
        file = ActiveStorage::Blob.service.send(:path_for, incase_import.import_file.key)
        # original_filename = incase_import.import_file.blob
        @content_type = incase_import.import_file.blob.content_type
        # @file = File.new(file)
        @file = ActiveStorage::Blob.service.send(:path_for, incase_import.import_file.key)
        @header
        @file_data = []
        @import_data
        @check_message = {success: [], errors: []}
        @check_import = false
    end

    def check_import
        @check_import = true
        import
        check_nested_incase_item_statuses
        if @check_message[:errors]
            @incase_import.update!(check: false)
            return false, @check_message
        else
            @incase_import.update!(check: true)
            @check_message[:success].push('all good')
            return true, @check_message
        end
    end

    def import
        collect_data
        file_uniq_column = @columns.where(column_system: @incase_import.uniq_field)[0].column_file
        system_columns = @columns.where.not(column_system: [nil,''])

        incase_columns = system_columns.select{|c| c.column_system.include?('incase#')}
        incase_item_columns = system_columns.select{|c| c.column_system.include?('incase_item#')}

        @check_message[:errors].push("you don't have details in file") if @check_import && !incase_item_columns.present?

        @import_data[:file_data].each do |line|
            # images_data = []
            # variant_images_data = []
            incase_data = Hash.new
            incase_item_data = Hash.new
            incase_columns.each do |pc|
                key = pc.column_system.remove('incase#')
                value = line[pc.column_file]
                if !key.include?('_id')
                    incase_data["#{key}"] = value if key != 'images' && key != file_uniq_column
                else
                    id = search_id_of_relation_column(key, value)
                    incase_data["#{key}"] = id
                end
                # images_data.push(value) if key == 'images'
            end
            incase_item_columns.each do |pc|
                key = pc.column_system.remove('incase_item#')
                value = line[pc.column_file]
                if !key.include?('_id')
                    incase_item_data["#{key}"] = value if key != 'images' && key != file_uniq_column
                else
                    id = search_id_of_relation_column(key, value)
                    incase_item_data["#{key}"] = id
                end
                # variant_images_data.push(value) if key == 'images'
            end

            puts "##########"
            puts "incase import uniq field => "+@incase_import.uniq_field.to_s
            #puts "line[file_uniq_column] => "+line[file_uniq_column].to_s
            puts "file uniq column => "+file_uniq_column.to_s
            puts "incase_data => "+incase_data.to_s
            puts "incase_item_data => "+incase_item_data.to_s
            puts "##########"

            incase = Incase.where("#{@incase_import.uniq_field.remove('incase#')}" => line[file_uniq_column] ) if !@check_import
            create_update_incase_and_items( incase.take, incase_data, incase_item_data ) if !@check_import
        end
    end
    
    private
    
    def collect_data
        puts 'collect_data import file '+Time.now.to_s
        spreadsheet = open_spreadsheet(@file)
        header = spreadsheet.row(1)
        @header = header
        (2..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
            @file_data.push(row)
        end
        puts 'finish collect_data import file '+Time.now.to_s
        @check_message[:success].push( "Строк в файле => "+@file_data.count.to_s ) if @check_import && @file_data.present?
        @import_data = @header.present? && @file_data.present? ? {header: @header, file_data: @file_data} : false
    end

    def create_update_incase_and_items( incase, incase_data, incase_item_data )
        if incase
            incase.update(incase_data)
            create_update_incase_items(incase, incase_item_data)
            incase.automation_on_update
        else
            new_incase = Incase.new(incase_data)
            new_incase.save
            create_update_incase_items(new_incase, incase_item_data)
            new_incase.automation_on_create
        end
    end

    def search_id_of_relation_column(key, value)
        check_key = key.include?('strah') ? 'company_id' : key
        model = check_key.split('_id').first.camelize.constantize
        model_attributes = model.new.attributes
        
        search = model_attributes.include?('short_title') ? model.find_by_short_title(value) : model.find_by_title(value)
        search ? search.id : @check_message[:errors].push(I18n.t("activerecord.attributes.incase.#{check_key}")+" : "+value)
    end

    def create_update_incase_items(incase, incase_item_data)
        search_incase_item = incase.incase_items.where(incase_item_data)
        incase.incase_items.create!(incase_item_data.merge!(incase_item_status_id: IncaseItemStatus.order(:position).first.id)) if !search_incase_item.present?
    end

    def check_nested_incase_item_statuses
        @check_message.push("you don't have incase status in system") if IncaseItemStatus.all.count == 0
    end

    def open_spreadsheet(file)
        if file.is_a? String
            if  @content_type == "text/csv"
            #   Roo::CSV.new(file, csv_options: {col_sep: ";", quote_char: "\x00"})
              Roo::CSV.new(file,csv_options: {encoding: Encoding::UTF_8})
            else
              Roo::Excelx.new(file, file_warning: :ignore)
            end
        else
            case File.extname(file.original_filename)
            when '.csv' then Roo::CSV.new(file.path,csv_options: {encoding: Encoding::UTF_8}) # csv_options: {col_sep: ";",encoding: "windows-1251:utf-8"})
            when '.xls' then Roo::Excel.new(file.path)
            when '.xlsx' then Roo::Excelx.new(file.path)
            when '.XLS' then Roo::Excel.new(file.path)
            else raise "Unknown file type: #{file.original_filename}"
            end
        end      
    end
    
end
