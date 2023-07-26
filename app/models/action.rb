class Action < ApplicationRecord
    belongs_to :trigger
    validates :action_name, presence: true


    Name = [['Сменить статус убытка','incase_status_id#incase'],['Сменить тип убытка','incase_tip_id#incase'],['Отправить письмо по убытку','email#all']].freeze


    def title_values
        title = Action::Name.select{|n| n if n[1] == self.action_name}.flatten[0]
        collect_values = self.action_params.reject(&:blank?).join
        template_title = Template.find_by_id(collect_values.to_i).title if self.action_name.include?('email')
        
        self.action_name.include?('email') ? title+': '+template_title : title+': '+collect_values
    end

    def self.get_collection(action_name)
        attribute = action_name.split('#').first
        model =  action_name.split('#').last
        collection = []
        collection = IncaseStatus.pluck(:title, :id) if model == 'incase' && attribute == 'incase_status_id' #Incase::STATUS
        collection = IncaseTip.pluck(:title, :id) if model == 'incase' && attribute == 'incase_tip_id' #Incase::TIP
        collection = Template.pluck(:title, :id) if model == 'all' && attribute == 'email'
        collection
    end

    def self.ransackable_attributes(auth_object = nil)
        Action.attribute_names
    end
    
end
