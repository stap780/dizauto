class Export < ApplicationRecord
    validates :format, presence: true
    validates :title, presence: true


    def self.ransackable_attributes(auth_object = nil)
      Export.attribute_names
    end

    def products #используется для liquid (но далее здесь можно переопределять товары которые надо выгрузить в экспорт)
      self.test == true ? Product.all.order(:id).limit(100) : Product.all.order(:id)
    end


end
