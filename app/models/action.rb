class Action < ApplicationRecord
  belongs_to :trigger
  validates :name, presence: true
  validates :value, presence: true

  Name = [["Сменить статус убытка", "incase_status_id#incase"],["Сменить тип убытка", "incase_tip_id#incase"],["Отправить письмо по убытку", "email#incase"],
          ["Сменить статус заказа", "order_status_id#order"],["Отправить письмо по заказу", "email#order"]].freeze
          #,["Создать поступление","create_supply#incase"]

  def title_values
    full_name = []
    attribute = name.split("#").first
    model = name.split("#").last
    title = Action::Name.select { |n| n if n[1] == name }.flatten[0]

    if name.include?("email")
      find_title = Templ.find_by_id(value.to_i).title
      full_name.push(title + ": " + find_title)
    end

    if !name.include?("email")
      find_title = IncaseStatus.where(id: value.to_i).first.title if attribute == "incase_status_id"
      find_title = IncaseTip.where(id: value.to_i).first.title if attribute == "incase_tip_id"
      find_title = OrderStatus.where(id: value.to_i).first.title if attribute == "order_status_id"
      find_title = value if model == "incase" && attribute == "create_supply"
      full_name.push(title + ": " + find_title)
    end
    full_name.join || "не нашли полное название действия"
  end

  def self.get_collection(name)
    attribute = name.split("#").first
    model = name.split("#").last
    collection = []
    collection = IncaseStatus.pluck(:title, :id) if model == "incase" && attribute == "incase_status_id"
    collection = IncaseTip.pluck(:title, :id) if model == "incase" && attribute == "incase_tip_id"
    collection = Templ.where(modelname: "incase").pluck(:title, :id) if model == "incase" && attribute == "email"
    collection = OrderStatus.pluck(:title, :id) if model == "order" && attribute == "order_status_id"
    collection = Templ.where(modelname: "order").pluck(:title, :id) if model == "order" && attribute == "email"
    collection = Templ.where(modelname: "incase_supply").pluck(:title, :id) if model == "incase" && attribute == "create_supply"
    puts collection.inspect
    collection
  end
  
  def self.ransackable_attributes(auth_object = nil)
    Action.attribute_names
  end

end
