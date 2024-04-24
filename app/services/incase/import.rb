class Incase::Import
  require "open-uri"
  include Rails.application.routes.url_helpers
  attr_accessor :incase_import, :columns, :header, :file_data, :import_data, :check_message

  def initialize(incase_import)
    puts "IncaseImport::Import initialize"
    @incase_import = incase_import
    @columns = @incase_import.incase_import_columns
    # file = Rails.application.routes.url_helpers.url_for(incase_import.import_file)
    # file = ActiveStorage::Blob.service.path_for(incase_import.import_file.key)
    # file = ActiveStorage::Blob.service.send(:path_for, incase_import.import_file.key)
    # original_filename = incase_import.import_file.blob
    @content_type = incase_import.import_file.blob.content_type
    # @file = File.new(file)
    host = Rails.env.development? ? "http://localhost:3000" : "https://erp.dizauto.ru"
    @file = host+rails_blob_path(incase_import.import_file, only_path: true) if incase_import.import_file.attached? #ActiveStorage::Blob.service.send(:path_for, incase_import.import_file.key)
    @file_data = []
    @work_data = []
    @check_message = {success: [], errors: []}
    @check_import = false
    @virtual_incase = {incase: {}, incase_items_attributes: {}}
    collect_data
  end

  def check_file
    @check_import = true
    import # we use it for check data
    check_nested_incase_item_statuses
    puts "@check_message[:errors] => "+@check_message[:errors].to_s
    if @check_message[:errors].size > 0
      @incase_import.update!(check: false)
      [false, @check_message]
    else
      @incase_import.update!(check: true)
      @check_message[:success].push("all good")
      [true, @check_message]
    end
  end

  def import
    collect_data
    file_uniq_column = @columns.where(column_system: @incase_import.uniq_field)[0].column_file
    system_columns = @columns.where.not(column_system: [nil, ""])

    incase_columns = system_columns.select { |c| c.column_system.include?("incase#") }
    incase_item_columns = system_columns.select { |c| c.column_system.include?("incase_item#") }

    @check_message[:errors].push("you don't have details in file") if @check_import && !incase_item_columns.present?

    @import_data[:file_data].each_with_index do |line, index|
      # images_data = []
      # variant_images_data = []
      incase_data = {}
      incase_item_data = {}
      incase_columns.each do |pc|
        key = pc.column_system.remove("incase#")
        value = line[pc.column_file]
        if !key.include?("_id")
          incase_data["#{key}"] = value if key != "images" && key != file_uniq_column
        else
          id = search_id_of_relation_column(key, value)
          incase_data["#{key}"] = id
        end
        # images_data.push(value) if key == 'images'
      end
      incase_item_columns.each do |pc|
        key = pc.column_system.remove("incase_item#")
        value = line[pc.column_file]
        if !key.include?("_id")
          incase_item_data["#{key}"] = value if key != "images" && key != file_uniq_column
        else
          id = search_id_of_relation_column(key, value)
          incase_item_data["#{key}"] = id
        end
        # variant_images_data.push(value) if key == 'images'
      end

      puts "##########"
      puts "incase import uniq field => " + @incase_import.uniq_field.to_s
      # puts "line[file_uniq_column] => "+line[file_uniq_column].to_s
      puts "file uniq column => " + file_uniq_column.to_s
      puts "incase_data => " + incase_data.to_s
      puts "incase_item_data => " + incase_item_data.to_s
      puts "##########"

      if !@check_import
        # this is for import process
        incase_data["incase_item_data"] = incase_item_data
        @work_data.push(incase_data)
      end
      if @check_import
        # this is for check import process
        line_validate_incase(index + 2, incase_data)
        line_validate_incase_items(index + 2, incase_item_data)
      end
    end

    # puts @work_data.to_s

    # this is for import process
    unless @check_import
      create_incases
      if @check_message[:errors].size > 0
        @incase_import.update!(check: false)
        [false, @check_message]
      else
        @incase_import.update!(check: true)
        @check_message[:success].push("Импорт Убытков завершен")
        [true, @check_message]
      end     
    end

  end

  private

  def collect_data
    puts "collect_data import file " + Time.now.to_s
    @file_data.clear
    spreadsheet = open_spreadsheet(@file)
    header = spreadsheet.row(1)
    @header = header
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      @file_data.push(row)
    end
    puts "finish collect_data import file " + Time.now.to_s
    @check_message[:success].push("Строк в файле => " + @file_data.count.to_s) if @check_import && @file_data.present?
    @import_data = (@header.present? && @file_data.present?) ? {header: @header, file_data: @file_data} : false
  end

  def create_incases
    uniq_field = "#{@incase_import.uniq_field.remove("incase#")}"
    datas_by_uniq = @work_data.group_by { |a| a[uniq_field] }
    datas_by_uniq.each do |key, value|
      incase_data = @work_data.select { |n| n[uniq_field] == key }[0]
      incase_data["incase_items_attributes"] = {}
      value.each_with_index do |val, index|
        # puts "val"
        # puts val["incase_item_data"]
        incase_item_data_hash = {}
        incase_item_data_hash["#{index}"] = val["incase_item_data"]
        # puts "incase_item_data_hash"
        # p incase_item_data_hash
        incase_data["incase_items_attributes"].merge!(incase_item_data_hash)
      end
      incase_data.delete("incase_item_data")
      puts incase_data
      incase = Incase.create!(incase_data)
      # incase.automation_on_create # пробую callback
    end
  end

  def line_validate_incase(index, incase_data)
    incase = Incase.new(incase_data)
    if incase.validate == false && incase.errors.full_messages.present?
      puts "line_validate_incase full_messages => "+incase.errors.full_messages.to_s
      @check_message[:errors].push("Строка #{index} в файле => " + incase.errors.full_messages.join(" "))
    end
  end

  def line_validate_incase_items(index, incase_item_data)
    incase_item = IncaseItem.new(incase_item_data)
    if incase_item.validate == false && incase_item.errors.delete(:incase) && incase_item.errors.full_messages.present?
      puts "line_validate_incase_items full_messages => "+incase_item.errors.full_messages.to_s
      @check_message[:errors].push("Строка #{index} в файле => " + incase_item.errors.full_messages.join(" "))
    end
  end

  def search_id_of_relation_column(key, value)
    check_key = key.include?("strah") ? "company_id" : key
    model = check_key.split("_id").first.camelize.constantize
    model_attributes = model.new.attributes

    search = model_attributes.include?("short_title") ? model.find_by_short_title(value) : model.find_by_title(value)
    search ? search.id : @check_message[:errors].push(I18n.t("activerecord.attributes.incase.#{check_key}") + " : " + value)
  end

  def create_update_incase_items(incase, incase_item_data)
    search_incase_item = incase.incase_items.where(incase_item_data)
    if !search_incase_item.present?
      incase.incase_items.create!(incase_item_data)
    else
      incase.incase_items.update!(incase_item_data)
    end
  end

  def check_nested_incase_item_statuses
    @check_message[:errors].push("=== you don't have incase item status in system ===") if IncaseItemStatus.all.count == 0
  end

  def open_spreadsheet(file)
    if file.is_a? String
      if @content_type == "text/csv"
        #   Roo::CSV.new(file, csv_options: {col_sep: ";", quote_char: "\x00"})
        Roo::CSV.new(file, csv_options: {encoding: Encoding::UTF_8})
      else
        Roo::Excelx.new(file, file_warning: :ignore)
      end
    else
      case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: Encoding::UTF_8}) # csv_options: {col_sep: ";",encoding: "windows-1251:utf-8"})
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      when ".XLS" then Roo::Excel.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
      end
    end
  end

end
