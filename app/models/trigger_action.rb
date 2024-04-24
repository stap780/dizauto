class TriggerAction < ApplicationRecord
  belongs_to :trigger
  validates :name, presence: true
  validates :value, presence: true

  include ActionView::RecordIdentifier

  after_create_commit do 
    broadcast_append_to [trigger, :trigger_actions], target: dom_id(trigger, :trigger_actions), partial: "trigger_actions/trigger_action", locals: { trigger_action: self, trigger: trigger  }
    broadcast_update_to [trigger, :trigger_actions], target: dom_id(trigger, dom_id(TriggerAction.new)), html: ''
  end

  after_update_commit do
      broadcast_replace_to [trigger, :trigger_actions], target: dom_id(trigger, dom_id(self)), partial: "trigger_actions/trigger_action", locals: { trigger_action: self, trigger: trigger }
  end

  after_destroy_commit do
    broadcast_remove_to [trigger, :trigger_actions], target: dom_id(trigger, dom_id(self))
  end


  ACTIONS = {
              "incase_status_id#incase": IncaseStatus.pluck(:title, :id),
              "incase_tip_id#incase": IncaseTip.pluck(:title, :id),
              "incase_item_status_id#incase_item": IncaseItemStatus.pluck(:title, :id),
              "email#incase": Templ.where(modelname: "incase").pluck(:title, :id),
              "order_status_id#order": OrderStatus.pluck(:title, :id),
              "email#order": Templ.where(modelname: "order").pluck(:title, :id)
            }.freeze

  # Name = [["Сменить статус убытка", "incase_status_id#incase"],["Сменить тип убытка", "incase_tip_id#incase"],["Отправить письмо по убытку", "email#incase"],
  #         ["Сменить статус заказа", "order_status_id#order"],["Отправить письмо по заказу", "email#order"]].freeze
  #         #,["Создать поступление","create_supply#incase"]


  def names
    ACTIONS.keys
  end

  def name_title
    I18n.t(self.name, :scope => :trigger_actions)
  end

  def names_collection
    I18n.t(:trigger_actions).map { |key, value| [ value, key ] }
  end

  def values(name)
    return [] unless name.present?

    ACTIONS[name.to_sym] || []
  end

  def title_values
    "не нашли полное название действия"
    # full_name = []
    # attribute = name.split("#").first
    # model = name.split("#").last
    # title = Action::Name.select { |n| n if n[1] == name }.flatten[0]

    # if name.include?("email")
    #   tmpl = Templ.find_by_id(value.to_i)
    #   find_title = tmpl.title if !tmpl.nil? && tmpl.count > 0
    #   full_name.push(title + ": " + find_title.to_s)
    # end

    # if !name.include?("email")
    #   i_s = IncaseStatus.where(id: value.to_i) if attribute == "incase_status_id"
    #   find_title = i_s.first.title if !i_s.nil? && i_s.count > 0 && attribute == "incase_status_id"

    #   i_t = IncaseTip.where(id: value.to_i) if attribute == "incase_tip_id"
    #   find_title = i_t.first.title if !i_t.nil? && i_t.count > 0 && attribute == "incase_tip_id"

    #   o_s = OrderStatus.where(id: value.to_i) if attribute == "order_status_id"
    #   find_title = o_s.first.title if !o_s.nil? && o_s.count > 0 && attribute == "order_status_id"
    #   # find_title = value if model == "incase" && attribute == "create_supply"
    #   full_name.push(title + ": " + find_title.to_s)
    # end
    # full_name.join || "не нашли полное название действия"
  end

  def value_title
    return '' unless name.present?
    self.values(self.name).map{|a| a[0] if  a[1] == self.value.to_i}.compact.join
  end
  
  def self.ransackable_attributes(auth_object = nil)
    TriggerAction.attribute_names
  end

end
