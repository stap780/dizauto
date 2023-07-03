class Permission < ApplicationRecord
    belongs_to :user

    Actions = ["read","create","update","destroy"]
    
    def self.ransackable_attributes(auth_object = nil)
      Export.attribute_names
    end


    def self.all_models
        Rails.application.eager_load! if Rails.env.development?
        not_use = ["User","SchemaMigration","ArInternalMetadatum","ActiveStorageAttachment","ActiveStorageBlob","ActiveStorageVariantRecord","ActionTextRichText","Permission"]
        all_models = ActiveRecord::Base.connection.tables.map do |model|
          value = model.capitalize.singularize.camelize
          value if !not_use.include?(value)
        end
        all_models.delete_if {|x| x == 3 }.compact
    end

end