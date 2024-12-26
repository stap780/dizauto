# Permission
class Permission < ApplicationRecord
  belongs_to :user
  Actions = %w[read create update destroy].freeze
  NOT_USE_MODELS = %w[
    return_items invoice_items detal_props images noticed_notifications noticed_events supply_items
    incase_import_columns dashboards company_plan_dates trigger_actions schema_migrations props incase_items
    order_items client_companies locations loss_items enter_items stock_transfer_items
    audits users schema_migrations action_text_rich_texts ar_internal_metadata variants
    active_storage_attachments active_storage_blobs active_storage_variant_records action_text_rich_text permissions
  ].freeze

  def self.ransackable_attributes(auth_object = nil)
    Export.attribute_names
  end

  def self.all_models
    Rails.application.eager_load! if Rails.env.development?
    all_models = ActiveRecord::Base.connection.tables.map do |model|
      # value = model.capitalize.singularize.camelize
      # model.singularize.classify.constantize unless not_use.include?(model)
      model.singularize.classify.constantize.name unless Permission::NOT_USE_MODELS.include?(model)
    end
    # result = all_models.delete_if { |x| x == 3 }.compact
    result = all_models.compact
    Permission.models_alphabetically(result)
  end

  def self.models_alphabetically(result)
    result.map{|a| [a ,a.singularize.classify.constantize.model_name.human(count: 2).capitalize]}.sort_by{|a| a[1]}.map{|a| a[0]}
  end

  def self.sort_alphabetically
    datas = Permission.all.collect{|a| 
      [a.id, a.pmodel.singularize.classify.constantize.model_name.human(count: 2).capitalize] unless Permission::NOT_USE_MODELS.include?(a.pmodel.underscore.pluralize)
    }
    ids = datas.reject(&:blank?).sort_by{|a| a[1]}.map{|a| a[0]}
    Permission.where(id: ids)
  end

  def self.sort_descending(result)
    return [] if result.empty?

    is_sorted = true
    while is_sorted
      is_sorted = false
      (result.size - 1).times do |i|
        if result[i] < result[i + 1]
          result[i], result[i + 1] = result[i + 1], result[i]
          is_sorted = true
        end
      end
    end
    result
  end

  def self.sort_ascending(result)
    return [] if result.empty?

    is_sorted = true
    while is_sorted
      is_sorted = false
      (result.size - 1).times do |i|
        if result[i] > result[i + 1]
          result[i], result[i + 1] = result[i + 1], result[i]
          is_sorted = true
        end
      end
    end
    result
  end

end
