class Permission < ApplicationRecord
    belongs_to :user
    validates :user_id, presence: true

    Actions = ["read","create","update","destroy"]
    
    def self.ransackable_attributes(auth_object = nil)
      Export.attribute_names
    end


    def self.all_models
        Rails.application.eager_load! if Rails.env.development?
        # not_use = ["Comment","Prop","IncaseItem","OrderItem","ClientCompany","Audit","User","SchemaMigration","ArInternalMetadatum","ActiveStorageAttachment","ActiveStorageBlob","ActiveStorageVariantRecord","ActionTextRichText","Permission"]
        not_use = ["supply_items","incase_import_columns","dashboards","company_plan_dates","actions","schema_migrations","comments","props","incase_items","order_items","client_companies","audits","users","schema_migrations","action_text_rich_texts","ar_internal_metadata","active_storage_attachments","active_storage_blobs","active_storage_variant_records","action_text_rich_text","permissions"]
        all_models = ActiveRecord::Base.connection.tables.map do |model|
          # value = model.capitalize.singularize.camelize
          if !not_use.include?(model)
            value = model.singularize.classify.constantize
            # value.model_name.human(count: 2).capitalize
          end
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