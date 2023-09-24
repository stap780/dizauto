class Action < ApplicationRecord
    belongs_to :trigger
    validates :action_name, presence: true


    Name = [['Сменить статус убытка','incase_status_id#incase'],['Сменить тип убытка','incase_tip_id#incase'],['Отправить письмо по убытку','email#incase']].freeze


    def title_values
        full_name = []
        attribute = self.action_name.split('#').first
        model =  self.action_name.split('#').last
        collect_values = self.action_params.reject(&:blank?).join
        title = Action::Name.select{|n| n if n[1] == self.action_name}.flatten[0]

        if self.action_name.include?('email')
            find_title = Templ.find_by_id(collect_values.to_i).title
            full_name.push(title+': '+find_title)
        end
        
        if !self.action_name.include?('email')
            find_title = IncaseStatus.where(id: collect_values).first.title if model == 'incase' && attribute == 'incase_status_id'
            find_title = IncaseTip.where(id: collect_values).first.title if model == 'incase' && attribute == 'incase_tip_id'
            full_name.push(title+': '+find_title)
        end
        full_name.join || 'не нашли полное название действия'
    end

    def self.get_collection(action_name)
        attribute = action_name.split('#').first
        model =  action_name.split('#').last
        collection = []
        collection = IncaseStatus.pluck(:title, :id) if model == 'incase' && attribute == 'incase_status_id'
        collection = IncaseTip.pluck(:title, :id) if model == 'incase' && attribute == 'incase_tip_id'
        collection = Templ.pluck(:title, :id) if model == 'incase' && attribute == 'email'
        puts collection.inspect
        collection
    end

    def self.ransackable_attributes(auth_object = nil)
        Action.attribute_names
    end
    
end
