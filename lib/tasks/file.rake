namespace :file do
  desc "work file"
  task create_log_zip_every_day: :environment do
    puts "start create_log_zip_every_day"
    if !Rails.env.development?
      folder = "/var/www/dizauto/shared/log/"
      file_names = ["nginx.access.log", "nginx.error.log", "production.log", "puma.access.log", "puma.error.log"]
      zip_folder = "/var/www/dizauto/shared/log/zip/"
      time = Time.zone.now.strftime("%d_%m_%Y_%I_%M")

      file_names.each do |f_name|
        file_path = File.join(folder, f_name)
        zipfile_name = "#{zip_folder}#{f_name}_#{time}.zip"
        Zip::File.open(zipfile_name, create: true) do |zipfile|
          zipfile.add(f_name, file_path)
        end

        log_file = "#{folder}#{f_name}"
        File.write(log_file, "Time - #{Time.zone.now}")
        FileUtils.chown("dizautodep", "dizautodep", file_path)
      end
    end
    puts "finish create_log_zip_every_day"
  end

  desc "TODO"
  task delete_unattached_blobs_every_day: :environment do
    puts "start delete_blobs_every_day"
    ActiveStorage::Blob.unattached.each(&:purge_later)
    # ActiveStorage::Blob.unattached.each(&:purge)
    puts "finish delete_blobs_every_day"
  end
end
