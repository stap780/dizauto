# TriggerAction < ApplicationRecord
class TriggerAction < ApplicationRecord
  belongs_to :trigger
  validates :name, presence: true
  validates :value, presence: true

  include ActionView::RecordIdentifier

  after_create_commit do 
    broadcast_append_to [trigger, :trigger_actions], target: dom_id(trigger, :trigger_actions), partial: 'trigger_actions/trigger_action', locals: { trigger_action: self, trigger: trigger  }
    broadcast_update_to [trigger, :trigger_actions], target: dom_id(trigger, dom_id(TriggerAction.new)), html: ''
  end

  after_update_commit do
    broadcast_replace_to [trigger, :trigger_actions], target: dom_id(trigger, dom_id(self)), partial: 'trigger_actions/trigger_action', locals: { trigger_action: self, trigger: trigger }
  end

  after_destroy_commit do
    broadcast_remove_to [trigger, :trigger_actions], target: dom_id(trigger, dom_id(self))
  end

  ACTIONS = {
    "incase_status_id#incase": IncaseStatus.pluck(:title, :id),
    "incase_tip_id#incase": IncaseTip.pluck(:title, :id),
    "incase_item_status_id#incase_item": IncaseItemStatus.pluck(:title, :id),
    "email#incase": Templ.where(modelname: 'incase').pluck(:title, :id),
    "order_status_id#order": OrderStatus.pluck(:title, :id),
    "email#order": Templ.where(modelname: 'order').pluck(:title, :id),
    "email#invoice": Templ.where(modelname: 'invoice').pluck(:title, :id),
    "invoice_status_id#invoice": InvoiceStatus.pluck(:title, :id)
  }

  def names
    ACTIONS.keys
  end

  def name_title
    I18n.t(name, scope: :trigger_actions)
  end

  def names_collection
    I18n.t(:trigger_actions).map { |key, value| [value, key] }
  end

  def values(name)
    return [] unless name.present?

    ACTIONS[name.to_sym] || []
  end

  def title_values
    'не нашли полное название действия'
  end

  def value_title
    return '' unless name.present?

    values(name).map{|a| a[0] if  a[1] == value.to_i}.compact.join
  end

  def self.ransackable_attributes(auth_object = nil)
    TriggerAction.attribute_names
  end

end
