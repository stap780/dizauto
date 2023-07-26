class Permission < ApplicationRecord
    belongs_to :user
    validates :user_id, presence: true

    Actions = ["read","create","update","destroy"]
    
    def self.ransackable_attributes(auth_object = nil)
      Export.attribute_names
    end


    def self.all_models
        Rails.application.eager_load! if Rails.env.development?
        not_use = ["Prop","IncaseItem","OrderItem","ClientCompany","Audit","User","SchemaMigration","ArInternalMetadatum","ActiveStorageAttachment","ActiveStorageBlob","ActiveStorageVariantRecord","ActionTextRichText","Permission"]
        all_models = ActiveRecord::Base.connection.tables.map do |model|
          value = model.capitalize.singularize.camelize
          value if !not_use.include?(value)
        end
        result = all_models.delete_if {|x| x == 3 }.compact
        sort_result = Permission.sort_ascending(result)
    end

    def self.sort_descending(array)
      return [] if array.empty?
      is_sorted = true
    
      while is_sorted
        is_sorted = false
    
        (array.size - 1).times do |i|
          if array[i] < array[i + 1]
            array[i], array[i + 1] = array[i + 1], array[i]
            is_sorted = true
          end
        end
      end
      array
    end

    def self.sort_ascending(array)
      return [] if array.empty?
      is_sorted = true
    
      while is_sorted
        is_sorted = false
    
        (array.size - 1).times do |i|
          if array[i] > array[i + 1]
            array[i], array[i + 1] = array[i + 1], array[i]
            is_sorted = true
          end
        end
      end
      array
    end

end