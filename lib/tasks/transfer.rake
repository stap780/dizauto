#  encoding : utf-8
namespace :transfer do
    desc "work transfer"
    require 'open-uri'
    require 'rake'
    require 'roo'

    task company: :environment do
      puts "start transfer company"
      file = 'companies.csv'

      # Rake::Task["transfer:open_spreadsheet"].invoke(file)
      # Rake::Task["transfer:open_spreadsheet"].reenable

      download_path = Rails.env.development? ? "#{Rails.public_path}/#{file}" : "/var/www/dizauto/shared/public/#{file}"
      # puts "download_path => "+download_path.to_s
      # tmp_file = File.open(download_path) IO.copy_stream(download_response, download_path)
      #spreadsheet = Rake::Task["transfer:open_spreadsheet"].invoke(download_path) #execute #invoke
      spreadsheet = Roo::CSV.new(download_path, csv_options: {encoding: Encoding::UTF_8})
      header = spreadsheet.row(1)

      (2..spreadsheet.last_row).each do |i|

        row = Hash[[header, spreadsheet.row(i)].transpose]
        puts row
        okrug = row["Округ"].to_s.present? ? row["Округ"].to_s : 'test_import'
        short_title = row["Название"].to_s.present? ? row["Название"].to_s : 'test_import'
        address = row["Адрес"].to_s.present? ? row["Адрес"].to_s : nil
        client_name = row["Имя контакта"].to_s.present? ? row["Имя контакта"].to_s : 'test_import'
        client_surname = row["Фамилия контакта"].to_s.present? ? row["Фамилия контакта"].to_s : nil
        client_phone = row["Телефон контакта"].to_s.present? ? row["Телефон контакта"].to_s : nil
        client_email = row["Почта контакта"].to_s.present? ? row["Почта контакта"].to_s : 'test_import@mail.ru'

        s_company = Company.find_by_short_title(short_title)
        s_okrug = Okrug.find_by_title(okrug)
        okrug = s_okrug.present? ? s_okrug : Okrug.create!(title: okrug)
        s_client = Client.find_by_email(client_email)
        client  = s_client.present? ? s_client : Client.create!(email: client_email, phone: client_phone, name: client_name, surname: client_surname)
        s_company = Company.find_by_short_title(short_title)
        company = s_company.present? ? s_company : 
                                        Company.create!(okrug_id: okrug.id, short_title: short_title, tip: 'стандартная', fact_address: address)
        client_company = company.client_companies.where(client_id: client.id).take
        ClientCompany.create(client_id: client.id, company_id: company.id) if !client_company.present?

      end		

      puts "finish transfer company"
    end



    task :open_spreadsheet, [:file] => :environment do |t, args|
      puts args[:file].is_a? String
        if args[:file].is_a? String
            #   Roo::CSV.new(file, csv_options: {col_sep: ";", quote_char: "\x00"})
            Roo::CSV.new(args[:file], csv_options: {encoding: Encoding::UTF_8}) if  @content_type == "text/csv"
            Roo::Excel.new(args[:file], file_warning: :ignore) if  @content_type == "text/xls"
            Roo::Excelx.new(args[:file], file_warning: :ignore) if  @content_type == "text/xlsx"
        else
            case File.extname(args[:file].original_filename)
            when '.csv' then Roo::CSV.new(args[:file].path,csv_options: {encoding: Encoding::UTF_8}) # csv_options: {col_sep: ";",encoding: "windows-1251:utf-8"})
            when '.xls' then Roo::Excel.new(args[:file].path)
            when '.xlsx' then Roo::Excelx.new(args[:file].path)
            when '.XLS' then Roo::Excel.new(args[:file].path)
            else raise "Unknown file type: #{args[:file].original_filename}"
            end
        end      
    end


end