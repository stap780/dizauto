class Export < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  # чтобы хранить файлы в ActiveStorage по фиксированному имени (https://my_domain.com/file_name.xml)
  # нужно создать домен третьего уровня и подключить его к сервису S3
  # это задача на потом
  
    validates :format, presence: true
    validates :title, presence: true


    def self.ransackable_attributes(auth_object = nil)
      Export.attribute_names
    end

    def products #используется для liquid (но далее здесь можно переопределять товары которые надо выгрузить в экспорт)
      self.test == true ? Product.all.order(:id).limit(100) : Product.all.order(:id)
    end

    def file_data
      if self.link.present?
        filename = self.link.split('/').last
        file = "#{Rails.public_path}/#{filename}"
        size = number_to_human_size(File.size(file))
        date = File.ctime(file).in_time_zone.strftime("%d/%m/%Y %H:%M" )
        "Размер: #{size} </br>Дата: #{date}".html_safe
      end
    end

end
