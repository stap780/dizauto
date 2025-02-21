require 'nokogiri'
require 'open-uri'
require 'csv'
require 'rest-client'
require 'zip'
require 'roo'

namespace :file do
  desc 'work file'
  task create_log_zip_every_day: :environment do
    puts 'start create_log_zip_every_day'
    next if Rails.env.development?

    folder = '/var/www/dizauto/shared/log/'
    file_names = ['nginx.access.log', 'nginx.error.log', 'production.log', 'puma.access.log', 'puma.error.log']
    zip_folder = '/var/www/dizauto/shared/log/zip/'
    time = Time.zone.now.strftime('%d_%m_%Y_%I_%M')

    file_names.each do |f_name|
      file_path = File.join(folder, f_name)
      zipfile_name = "#{zip_folder}#{f_name}_#{time}.zip"
      Zip::File.open(zipfile_name, create: true) do |zipfile|
        zipfile.add(f_name, file_path)
      end

      log_file = "#{folder}#{f_name}"
      File.write(log_file, "Time - #{Time.zone.now}")
      FileUtils.chown('dizautodep', 'dizautodep', file_path)
    end
    puts 'finish create_log_zip_every_day'
  end

  desc 'TODO'
  task delete_unattached_blobs_every_day: :environment do
    puts 'start delete_blobs_every_day'
    ActiveStorage::Blob.unattached.each(&:purge_later)
    # ActiveStorage::Blob.unattached.each(&:purge)
    puts 'finish delete_blobs_every_day'
  end

  desc 'Scrape prices from a website and delete nodes'
  task :parsing_url, [:locs] => :environment do |t, args|
    puts 'start parsing_url'
    proxy = {
      0 => '104.250.207.225:6623',
      1 => '107.173.137.229:6483',
      2 => '104.250.207.225:6623',
      3 => '107.173.137.229:6483',
      4 => '185.48.52.133:5725',
      5 => '45.43.184.136:5810',
      6 => '185.39.8.85:5742',
      7 => '216.173.99.104:6446',
      8 => '64.137.65.42:6721',
      9 => '45.43.68.115:5755'
    }
    proxy_username = 'quwmffzs'
    proxy_password = 'r41ybhmuyzvg'
    if args[:locs].present?
      locs = args[:locs]
    else
      url = 'https://pack24.ru/sitemap.xml'
      resp = RestClient::Request.execute(url: url, method: :get, verify_ssl: false, accept: :xml, content_type: 'application/xml', proxy: "http://#{proxy_username}:#{proxy_password}@#{proxy[0]}")
      filedoc = Nokogiri::HTML(resp)
      locs = filedoc.css('loc')
    end
    file = "#{Rails.public_path}/packs2.csv"
    CSV.open(file, 'w') do |csv_out|
      header = %w[link title price description cats images parametrs]
      csv_out << header

      locs.each_with_index do |loc, index|
        puts "=== index => #{index}"
        puts '    start parsing loc'
        proxy_ip = proxy[index.to_s.split('').last.to_i]
        link =  args[:locs].present? ? loc : loc.text
        RestClient::Request.execute(
          url: link,
          method: :get,
          verify_ssl: false,
          proxy: "http://#{proxy_username}:#{proxy_password}@#{proxy_ip}"
        ) { |page_resp, request, result, &block|
          puts "page_resp.code => #{page_resp.code}"
          case page_resp.code
          when 200
            doc = Nokogiri::HTML(page_resp)
            check_product = doc.css('.js_add-item-to-cart')

            # Skip iteration if product is not present
            if !check_product.present?
              puts "    this is not a product page => #{link}"
            else
              puts "    we find product page => #{link}"
              title = doc.css('h1').text.strip
              # price start
              doc.css('.js_tooltip').remove
              doc.css('.item__tooltip').remove
              doc.css('.item__price--with-discount').remove
              price_node = doc.css('.item__price.h-10')
              price = price_node.text.gsub('₽','').squish if price_node.text.respond_to?('squish')
              # price end

              description = doc.css('#description .main-text').text.strip
              cats = doc.css('[aria-label="Breadcrumb"]').css('a').map(&:text).join('/')
              imgs = doc.css('[property="og:image"]')[0]['content'].gsub('|assets','https://pack24.ru/storage/assets').split('|').join(', ')
              parametrs_node = doc.css('.list-dotted.hidden li')
              parametrs = parametrs_node.map{|p| [p.css('div span').text, p.css('.text-left').text.squish]}

              data = [link, title, price, description, cats, imgs, parametrs.map{|p| p.join(':')}.join('---')]

              csv_out << data
            end
          when 403
            puts 'error 403'
          when 404
            puts 'error 404'
          when 429
            puts 'error 429 Too Many Requests (RestClient::TooManyRequests)'
          when 408
            puts 'error 408 RestClient::Exceptions::OpenTimeout'
          when 500
            puts "error 500 link => #{link}"
          else
            page_resp.return!(&block)
          end
        }
      end
    end
    puts 'finish parsing_url'
  end

  desc 'csv update'
  task csv_update: :environment do
    file = "#{Rails.public_path}/packs.csv"
    new_file = "#{Rails.public_path}/packs_with_cats.csv"
    CSV.open(new_file, 'w') do |csv_out|
      rows = CSV.read(file, headers: true).collect(&:to_hash)
      # puts rows.inspect
      header_parametrs = []
      rows.each do |row|
        header_values = row['parametrs'].split('---').map{|t| "Параметр:#{t.split(':').first}" unless t.split(':').first.blank? }.flatten
        header_values.each do |val|
          header_parametrs << val
        end
      end
      column_names = rows.first.keys + ['Подкатегория 1', 'Подкатегория 2', 'Подкатегория 3', 'Подкатегория 4'] + header_parametrs.uniq.reject(&:blank?)
      csv_out << column_names
      CSV.foreach(file, headers: true ) do |row|
        # fid = row[0]
        cats = row['cats'].remove('Главная/Каталог/').split('/')
        cats.each_with_index do |cat, index|
          row["Подкатегория #{index+1}"] = cat
        end

        csv_out << row
      end
    end

    full_file = "#{Rails.public_path}/packs_full_file.csv"
    CSV.open(full_file, 'w') do |csv_out|
      rows = CSV.read(new_file, headers: true).collect(&:to_hash)
      column_names = rows.first.keys
      csv_out << column_names

      CSV.foreach(new_file, headers: true ) do |row|
        parametrs = row['parametrs'].split('---')
        parametrs.each do |par|
          unless par.split(':').first.blank?
            key = "Параметр:#{par.split(':').first}"
            value = par.split(':').last
            row[key] = value
          end
        end

        csv_out << row
      end
    end

  end

  task parsing_excel: :environment do
    base_file = "#{Rails.public_path}/packs.csv"
    base_rows = CSV.read(base_file, headers: true).collect(&:to_hash)
    already_links_we_have = base_rows.map{|r| r['link']}
    links = []
    file = "#{Rails.public_path}/price_ni_pack24.xlsx"
    sheet = Roo::Spreadsheet.open(file)
    header = sheet.row(5)
    (5..sheet.last_row).each do |i|
      row = Hash[[header, sheet.row(i)].transpose]
      link = sheet.hyperlink(i, 3)
      links.push(link) if link.present? && !already_links_we_have.include?(link)
    end
    puts "parsing_excel links count => #{links.count}"
    Rake::Task['file:parsing_url'].invoke(links)
    Rake::Task['file:parsing_url'].reenable
    # xlsx = Roo::Excelx.new(file)
    # xlsx.each_row_streaming do |row|
    #   puts row.inspect # Array of Excelx::Cell objects
    # end
  end
  desc 'Generate PDF from string with specific dimensions'
  task :generate_pdf, [:content] => :environment do |t, args|
    Array(1..1202).each do |i|
      puts "start index #{i} - #{Time.zone.now}"
      file = "qrcodes/#{i}.png"
      content = ActionController::Base.new.render_to_string(partial: 'shared/qr_custom', locals: { qr: file })
      # content = args[:content] || 'Default content for PDF'
      pdf = WickedPdf.new.pdf_from_string(
        content,
        page_height: '41',
        page_width: '65',
        margin: { top: 5, bottom: 5, left: 1, right: 1 },
        encoding: 'UTF-8'
      )

      file_path = Rails.root.join('public/qr', "g_#{i}.pdf")
      File.open(file_path, 'wb') do |file|
        file << pdf
      end
      puts "end index #{i} - #{Time.zone.now}"
      puts "PDF generated at #{file_path}"
    end
  end

  desc 'Combine PDF files from public directory into one file'
  task combine_pdfs: :environment do
    require 'combine_pdf'

    puts 'start combine_pdfs'
    pdf_dir = Rails.root.join('public/qr')
    combined_pdf = CombinePDF.new

    Dir.glob("#{pdf_dir}/*.pdf").each do |pdf_file|
      combined_pdf << CombinePDF.load(pdf_file)
    end

    output_file = Rails.root.join('public', 'combined.pdf')
    combined_pdf.save(output_file)

    puts "Combined PDF saved at #{output_file}"
    puts 'finish combine_pdfs'
  end
  
end
