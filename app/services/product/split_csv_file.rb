class Product::SplitCsvFile
    require 'open-uri'
    require "addressable/uri"

    # FileUtils.rm_rf(Dir["#{Rails.public_path}/test_img/*"])

    def initialize
        @url = "http://138.197.52.153/insales.csv"
        @filename = File.basename(@url, File.extname(@url))
        @extention = File.extname(@url)
        @download_path = Rails.env.development? ? "#{Rails.public_path}/csv/" : "/var/www/dizauto/shared/public/csv/"
        @main_file = @download_path+@filename+@extention
        @file_count = 3
        @split_files = Array.new
    end

    def call
        # load_main_file
        split
        @split_files if @split_files.present?
    end

    private

    def load_main_file
        download = URI.open(@url)
        File.delete(@download_path+@filename+@extention) if File.file?(@download_path+@filename+@extention)
        IO.copy_stream(download, @download_path+@filename+@extention)
    end

    def split
    puts 'split start'
        original = @main_file
        file_count = @file_count
        header_lines = 1
        lines = Integer(`cat #{original} | wc -l`) - header_lines
        lines_per_file = (lines / file_count.to_f).ceil + header_lines
        # header = `head -n #{header_lines} #{original}`
        header = CSV.foreach(@main_file, headers: false).take(1).flatten

        start = header_lines

        file_count.times.map do |i|
          finish = start + lines_per_file
          file = "#{original}-#{i}.csv"
          File.delete(file) if File.file?(file)
          # File.write(file, header)
          CSV.open(file, "wb", headers: false) do |csv|
            csv << header
            CSV.foreach(@main_file, headers: true, encoding:'iso-8859-1:utf-8').with_index do |row, index|
              csv << row if index >= start && index <= finish
            end
          end
          # sh "tail -n #{lines - start} #{original} | head -n #{lines_per_file} >> #{file}"
          start = finish
          @split_files.push(file)
        end
    puts 'split finish'
    end

end