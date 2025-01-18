# Permission < ApplicationRecord
class Permission < ApplicationRecord
  belongs_to :user
  validates :pmodel, presence: true, uniqueness: { scope: :user_id }
  validates :pactions, presence: true
  include ActionView::RecordIdentifier
  
  after_create_commit do 
    broadcast_append_to [user, :permissions], target: dom_id(user, :permissions), partial: 'permissions/permission',
                                              locals: { user: user, permission: self }
    # broadcast_update_to [detal, :detal_props], target: dom_id(detal, dom_id(DetalProp.new)), html: ''
  end

  after_update_commit do
    broadcast_replace_to [user, :permissions], target: dom_id(user, dom_id(self)), partial: 'permissions/permission',
                                                locals: { user: user, permission: self }
  end

  after_destroy_commit do
    broadcast_remove_to [user, :permissions], target: dom_id(user, dom_id(self))
  end

  def self.ransackable_attributes(auth_object = nil)
    Variant.attribute_names
  end

  ACTIONS = %w[read create update destroy].freeze
  NOT_USE_MODELS = %w[
    return_items invoice_items detal_props images noticed_notifications noticed_events supply_items
    incase_import_columns dashboards company_plan_dates trigger_actions schema_migrations props incase_items
    order_items client_companies locations loss_items enter_items stock_transfer_items
    audits users schema_migrations action_text_rich_texts ar_internal_metadata variants
    active_storage_attachments active_storage_blobs active_storage_variant_records action_text_rich_text permissions
    delivery shippings
  ]

  def self.ransackable_attributes(auth_object = nil)
    Export.attribute_names
  end

  def self.all_models
    Rails.application.eager_load! if Rails.env.development?
    all_models = ActiveRecord::Base.connection.tables.map do |model|
      model.singularize.classify.constantize.name unless Permission::NOT_USE_MODELS.include?(model)
    end
    result = all_models.compact
    Permission.models_alphabetically(result)
  end

  def self.models_alphabetically(result)
    puts "result => #{result}"
    result.map{|a| [a , a.singularize.classify.constantize.model_name.human(count: 2).capitalize]}.sort_by{|a| a[1]}.map{|a| [a[1], a[0]]}
  end

  def self.sort_alphabetically # check where we use this
    datas = Permission.all.collect{|a| 
      [a.id, a.pmodel.singularize.classify.constantize.model_name.human(count: 2).capitalize] unless Permission::NOT_USE_MODELS.include?(a.pmodel.underscore.pluralize)
    }
    ids = datas.reject(&:blank?).sort_by{|a| a[1]}.map{|a| a[0]}
    Permission.where(id: ids)
  end

  def pmodel_to_human
    pmodel.singularize.classify.constantize.model_name.human(count: 2).capitalize
  end


end
