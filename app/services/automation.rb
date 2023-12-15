class Automation < ApplicationService

    # Data for testing
    # tmpl = Liquid::Template.parse( "{% if incase.strah == 'Альфа' and incase.totalsum == 0 %}{{do_work}}{{incase.strah}}{% endif %}"  )
    # tmpl.render({'incase' => Drop::Incase.new(incase)}, { strict_variables: true })
    # end Data for testing

    def initialize(object)
        puts 'start automation initialize'
        @object = object
        @drop_object = @object.model_name.singular
        @drop = "Drop::#{@object.model_name.name}".constantize.new(@object)
        @create_triggers = Trigger.active.where(event: 'create_'+@drop_object) || nil
        @update_triggers = Trigger.active.where(event: 'update_'+@drop_object) || nil
    end

    def create
        if @create_triggers.present?
            @create_triggers.each do |trigger|
                if trigger.condition.include?('do_work')
                    puts 'we here - trigger.condition.include?( do_work ) => '+trigger.condition.include?('do_work').to_s
                    
                    # add to template our method that we use as check condition == true
                    template = Liquid::Template.parse(trigger.condition.gsub("do_work","#{@drop_object}.do_work"))
                    # puts 'automation template => '+template.to_s
                    # puts 'automation drop_object => '+@drop_object.to_s
                    # puts 'automation drop => '+@drop.to_s
                    check = template.render(@drop_object => @drop)
                    puts 'automation template.render check => '+check.to_s

                    check_render_value = check.squish if check.respond_to?("squish")

                    if check_render_value == "do_work"
                        puts 'automation template.render check_render_value.length => '+check_render_value.length.to_s
                        trigger.actions.each do |action|
                            wait = trigger.pause == true && trigger.pause_time.present? ? trigger.pause_time : 1

                            attr = action.action_name.split('#').first
                            value = action.action_params.reject(&:blank?).join

                            update_object(attr, value) if !action.action_name.include?('email')
                            send_email(attr, value, wait) if action.action_name.include?('email')

                        end
                    end
                end
            end
        end
    end

    def update
        if @update_triggers.present?
        puts 'start automation update'
            @update_triggers.each do |trigger|
                if trigger.condition.include?('do_work')
                    puts 'we here - trigger.condition.include?( do_work )'
                    
                    # add to template our method that we use as check condition == true
                    template = Liquid::Template.parse(trigger.condition.gsub("do_work","#{@drop_object}.do_work"))

                    check = template.render(@drop_object => @drop)
                    puts 'automation template.render check => '+check.to_s

                    check_render_value = check.squish if check.respond_to?("squish")

                    if check_render_value == "do_work"
                        puts 'automation template.render check_render_value.length => '+check_render_value.length.to_s
                        trigger.actions.each do |action|
                            wait = trigger.pause == true && trigger.pause_time.present? ? trigger.pause_time : 1

                            attr = action.action_name.split('#').first
                            value = action.action_params.reject(&:blank?).join

                            update_object(attr, value) if !action.action_name.include?('email')
                            send_email(attr, value, wait) if action.action_name.include?('email') && object_condition_attributes_have_changes?(template)

                        end
                    end
                end
            end
        puts 'finish automation update'
        end
    end

    def update_object(attr, value)
        hash = Hash.new
        hash[attr] = value
        puts 'automation update hash => '+hash.to_s
        @object.update(hash)
    end

    def send_email(attr, value, wait)
        action_template = Template.find(value)
        subject_template = Liquid::Template.parse(action_template.subject)
        content_template = Liquid::Template.parse(action_template.content)

        receiver = @object.client.email if action_template.receiver == 'client' && @drop_object == 'order'
        receiver = @object.company.main_email if action_template.receiver == 'client' && @drop_object == 'incase'
        receiver = user.email if action_template.receiver == 'user'
        receiver = @object.manager.email if action_template.receiver == 'user' && @drop_object == 'order'
        receiver = @object.manager.email if action_template.receiver == 'user' && @drop_object == 'supply'

        subject = subject_template.render( @drop_object => @drop )
        content = content_template.render( @drop_object => @drop )
                        
        email_data = {
                        email_setup: EmailSetup.all.first,
                        subject: subject,
                        content: content,
                        receiver: receiver
                    }

        AutomationMailer.with(email_data).send_action_email.deliver_later(wait: wait.to_i.minutes)
    end

    def object_condition_attributes_have_changes?(tmpl)
        object_have_changes = []
        # get object and attribute
        # tmpl = Liquid::Template.parse( "{% if incase.strah == 'Альфа' and incase.totalsum == 0 %}{{incase.strah}}{% endif %}" )
        check_attributes = Liquid::ParseTreeVisitor.for(tmpl.root).add_callback_for(Liquid::VariableLookup) do |node|
            [node.name, *node.lookups].join('.')
        end.visit.flatten.compact.uniq # => ["incase.strah", "incase.totalsum"] 

        # check changes
        check_attributes.each do |attribute|
            object_have_changes.push( @object.saved_change_to_attribute?(attribute.split('.').last) )
        end

        object_have_changes.uniq.size == 1 && object_have_changes.uniq.first == true ? true : false
    end

end