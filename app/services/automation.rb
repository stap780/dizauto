class Automation < ApplicationService

    def initialize(object)
        puts 'start automation initialize'
        @object = object
    end

    def create_triggers
        @create_triggers = Trigger.active.where(event: 'create_'+@object.model_name.singular) || nil
    end

    def update_triggers
        @update_triggers = Trigger.active.where(event: 'update_'+@object.model_name.singular) || nil
    end

    def create
        @create_triggers.each do |trigger|
            template = Liquid::Template.parse(trigger.condition)
            drop = "Drop::#{@object.model_name.name}".constantize.new(@object)
            check = template.render(@object.model_name.singular => drop)
        end
    end

    def update
        puts 'start automation update'
        @update_triggers.each do |trigger|
            if trigger.condition.include?('do_work')
                puts 'we here - trigger.condition.include?( do_work )'
                template = Liquid::Template.parse(trigger.condition.gsub("do_work","#{@object.model_name.singular}.do_work"))
                drop = "Drop::#{@object.model_name.name}".constantize.new(@object)
                check = template.render(@object.model_name.singular => drop)
                puts 'automation template.render check => '+check.to_s
                # tmpl = Liquid::Template.parse( "{% if incase.strah == 'Альфа' and incase.totalsum == 0 %}{{do_work}}{{incase.strah}}{% endif %}"  )
                # tmpl.render('incase' => Drop::Incase.new(incase))
                value = check.squish if check.respond_to?("squish")
                if value == "do_work"
                    puts 'automation template.render value.length => '+value.length.to_s
                    trigger.actions.each do |action|
                        if !action.action_name.include?('email')
                            hash = Hash.new
                            attr = action.action_name.split('#').first
                            value = action.action_params.reject(&:blank?).join
                            hash[attr] = value
                            puts 'automation update hash => '+hash.to_s
                            @object.update(hash)
                        end
                    end
                end
            end
        end
        puts 'finish automation update'
    end

end