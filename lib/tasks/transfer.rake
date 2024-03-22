#  encoding : utf-8
namespace :transfer do
  desc "work transfer"
  require "open-uri"
  require "addressable/uri"
  require "rake"
  require "roo"
  require "image_processing/vips"

  task company: :environment do
    puts "start transfer company"
    file = "companies.csv"[]

    # Rake::Task["transfer:open_spreadsheet"].invoke(file)
    # Rake::Task["transfer:open_spreadsheet"].reenable

    download_path = Rails.env.development? ? "#{Rails.public_path}/#{file}" : "/var/www/dizauto/shared/public/#{file}"
    # puts "download_path => "+download_path.to_s
    # tmp_file = File.open(download_path) IO.copy_stream(download_response, download_path)
    # spreadsheet = Rake::Task["transfer:open_spreadsheet"].invoke(download_path) #execute #invoke
    spreadsheet = Roo::CSV.new(download_path, csv_options: {encoding: Encoding::UTF_8})
    header = spreadsheet.row(1)

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      puts row
      okrug = row["Округ"].to_s.present? ? row["Округ"].to_s : "test_import"
      short_title = row["Название"].to_s.present? ? row["Название"].to_s : "test_import"
      address = row["Адрес"].to_s.present? ? row["Адрес"].to_s : nil
      client_name = row["Имя контакта"].to_s.present? ? row["Имя контакта"].to_s : "test_import"
      client_surname = row["Фамилия контакта"].to_s.present? ? row["Фамилия контакта"].to_s : nil
      client_phone = row["Телефон контакта"].to_s.present? ? row["Телефон контакта"].to_s : nil
      client_email = row["Почта контакта"].to_s.present? ? row["Почта контакта"].to_s : "test_import@mail.ru"

      s_company = Company.find_by_short_title(short_title)
      s_okrug = Okrug.find_by_title(okrug)
      okrug = s_okrug.present? ? s_okrug : Okrug.create!(title: okrug)
      s_client = Client.find_by_email(client_email)
      client = s_client.present? ? s_client : Client.create!(email: client_email, phone: client_phone, name: client_name, surname: client_surname)
      s_company = Company.find_by_short_title(short_title)
      company = s_company.present? ? s_company :
                                      Company.create!(okrug_id: okrug.id, short_title: short_title, tip: "стандартная", fact_address: address)
      client_company = company.client_companies.where(client_id: client.id).take
      ClientCompany.create(client_id: client.id, company_id: company.id) if !client_company.present?
    end

    puts "finish transfer company"
  end

  task :product, [:last_row] => :environment do |t, args|
    puts "start product"
    file_data = []
    url = "http://138.197.52.153/insales.csv"
    file = url.split("/").last
    # download = URI.open(url)
    download_path = Rails.env.development? ? "#{Rails.public_path}/#{file}" : "/var/www/dizauto/shared/public/#{file}"
    # File.delete(download_path) if File.file?(download_path)
    # IO.copy_stream(download, download_path)
    spreadsheet = Roo::CSV.new(download_path, csv_options: {encoding: Encoding::UTF_8})
    header = spreadsheet.row(1)

    properties = header.map { |h| h.remove("Параметр:").squish if h.include?("Параметр:") }.reject(&:blank?)
    properties.each do |property|
      Property.find_or_create_by!(title: property)
    end
    job_last_row = args[:last_row].present? ? args[:last_row] : spreadsheet.last_row
    last_row = Rails.env.development? ? 5 : job_last_row

    (2..last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      file_data.push(row)
    end

    file_data.each do |data|
      pr_data = {
        barcode: data["Артикул"],
        sku: data["Параметр: Артикул производителя"],
        title: data["Название товара"],
        description: data["Краткое описание"],
        quantity: data["Остаток"],
        costprice: data["costprice"],
        price: data["Цена продажи"],
        video: data["video"]
      }
      puts pr_data
      s_product = Product.find_by_barcode(pr_data[:barcode])
      if s_product
        s_product.update(pr_data)
        product = s_product
      else
        product = Product.create!(pr_data)
      end

      puts "product id => " + product.id.to_s
      images = data["Изображения"].to_s.present? ? data["Изображения"].split(" ") : nil
      saved_images_name = product.images.map { |image| image.filename.to_s }
      image_files = []
      # puts "saved_images_name => "+saved_images_name.to_s
      images.each do |url|
        # clear_url = url.squish if url.respond_to?("squish")
        clear_url = Addressable::URI.parse(url).normalize
        # puts "clear_url => "+clear_url.to_s
        # filename = File.basename(clear_url)
        filename = File.basename(url)
        # puts "filename => "+filename.to_s
        file = URI.open(clear_url)
        image_files << {io: file, filename: filename} if !saved_images_name.include?(filename)
      end
      check = product.images.attach(image_files)
      puts check

      props_for_create = []
      properties = data.select { |k, v| k.include?("Параметр:") }

      properties.each do |pro|
        # puts "pro => "+pro.to_s
        p_hash = {}
        # puts "p => "+p.to_s
        if pro[0].present? && pro[1].present?
          s_p = Property.find_or_create_by!(title: pro[0].remove("Параметр:").squish)
          s_char = s_p.characteristics.find_or_create_by!(title: pro[1])
          # puts "s_char => "+s_char.inspect.to_s
          p_hash["property_id"] = s_p.id
          p_hash["characteristic_id"] = s_char.id
        end
        # puts "p_hash => "+p_hash.to_s
        props_for_create.push(p_hash) if p_hash.present?
      end

      # puts "props_for_create => "+props_for_create.to_s
      props_for_create.each_with_index do |prop_hash, index|
        product.props.find_or_create_by!(prop_hash) # if index < 2
      end
    end

    puts "finish product"
  end

  task image_process: :environment do # тестировал и разюирался - много лишнего
    puts "start image_process"
    product = Product.first
    im_ids = product.images.ids
    puts product.images.ids
    puts product.image_urls
    image_files = []
    product.images.each do |image|
      puts "image"
      puts image
      puts "======="
      filename = image.filename
      e = MiniMagick::Image.open(image)
      puts "e"
      puts e
      puts "======="
      image_data = e.data
      quality = e.data["quality"]
      magick = ImageProcessing::MiniMagick.saver(quality: 78).call(e)

      # image.purge
      # product.images.attach(io: magick, filename: filename)
      image_files << {io: magick, filename: filename}
    end
    puts "image_files"
    puts image_files
    puts "======="
    product.images.attach(image_files)

    product.images.where(id: im_ids).each do |image|
      image.purge
    end
    puts "finish image_process"
  end

  task :open_spreadsheet, [:file] => :environment do |t, args|
    puts args[:file].is_a? String
    if args[:file].is_a? String
      #   Roo::CSV.new(file, csv_options: {col_sep: ";", quote_char: "\x00"})
      Roo::CSV.new(args[:file], csv_options: {encoding: Encoding::UTF_8}) if @content_type == "text/csv"
      Roo::Excel.new(args[:file], file_warning: :ignore) if @content_type == "text/xls"
      Roo::Excelx.new(args[:file], file_warning: :ignore) if @content_type == "text/xlsx"
    else
      case File.extname(args[:file].original_filename)
      when ".csv" then Roo::CSV.new(args[:file].path, csv_options: {encoding: Encoding::UTF_8}) # csv_options: {col_sep: ";",encoding: "windows-1251:utf-8"})
      when ".xls" then Roo::Excel.new(args[:file].path)
      when ".xlsx" then Roo::Excelx.new(args[:file].path)
      when ".XLS" then Roo::Excel.new(args[:file].path)
      else raise "Unknown file type: #{args[:file].original_filename}"
      end
    end
  end

  task test_image: :environment do
    p = Product.last
    t_i = "http://138.197.52.153/images/itemimages/1362486/original/20221010_120031.jpg"
    e = MiniMagick::Image.open(t_i) # открывает файл
    e.write("new_file") # сохраняет в новый файл преобразования
    filename = e.data["baseName"]
    content_type = e.data["mimeType"]
    magick = ImageProcessing::MiniMagick.saver(quality: 78).call(e) # преобразовывает и создаёт временный файл
    # стандартный вариант создания картинки
    image = p.images.create!
    image.file.attach(io: magick, filename: filename)
    # вариант с signed_id
    blob = ActiveStorage::Blob.create_and_upload!(io: magick, filename: filename, content_type: content_type)
    # blob = ActiveStorage::Blob.find_signed(signed_id)
    # blob.signed_id
    image = p.images.create!
    image.file.attach(blob.signed_id)
  end

  # not work or i don't understand
  task split_file: :environment do
    filename = "insales.csv"
    download_path = Rails.env.development? ? "#{Rails.public_path}/csv/#{filename}" : "/var/www/dizauto/shared/public/csv/#{filename}"
    # download = URI.open("http://138.197.52.153/insales.csv")
    # File.delete(@download_path) if File.file?(download_path)
    # IO.copy_stream(download, download_path)
    original = download_path
    file_count = 2
    header_lines = 1
    lines = Integer(`cat #{original} | wc -l`) - header_lines
    lines_per_file = (lines / file_count.to_f).ceil + header_lines
    # header = `head -n #{header_lines} #{original}`
    header = CSV.foreach(download_path, headers: false).take(1).flatten

    start = header_lines

    file_count.times.map do |i|
      finish = start + lines_per_file

      file = "#{original}-#{i}.csv"

      # File.write(file, header)

      CSV.open(file, "wb", headers: false) do |csv|
        csv << header
        CSV.foreach(download_path, headers: true).with_index do |row, index|
          csv << row if index >= start && index <= finish
        end
      end

      # sh "tail -n #{lines - start} #{original} | head -n #{lines_per_file} >> #{file}"

      start = finish
      puts "we finish"
      file
    end
    puts "task finish"
  end
end
