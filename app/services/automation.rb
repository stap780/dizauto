# frozen_string_literal: true

# Automation < ApplicationService
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
    @create_triggers = Trigger.active.where(event: "create_#{@drop_object}") || nil
    @update_triggers = Trigger.active.where(event: "update_#{@drop_object}") || nil
  end

  def create
    if @create_triggers.present?
      @create_triggers.each do |trigger|
        if trigger.condition.include?('do_work')
          puts 'we here create - trigger.condition.include?(do_work)'

          # add to template our method that we use as check condition == true
          template = Liquid::Template.parse(trigger.condition.gsub('do_work', "#{@drop_object}.do_work"))
          # puts 'automation template => '+template.to_s
          # puts 'automation drop_object => '+@drop_object.to_s
          # puts 'automation drop => '+@drop.to_s
          check = template.render(@drop_object => @drop)
          puts "automation template.render check => #{check}"

          check_render_value = check.squish if check.respond_to?(:squish)

          if check_render_value == 'do_work'
            puts "automation template.render check_render_value.length => #{check_render_value.length}"
            wait = trigger.pause && trigger.pause_time.present? ? trigger.pause_time : 1
            trigger.trigger_actions.each do |action|

              attr = action.name.split('#').first

              update_object(attr, action.value) unless action.name.include?('email')
              send_email(attr, action.value, wait) if action.name.include?('email')
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
          puts 'we here update - trigger.condition.include?(do_work)'

          # add to template our method that we use as check condition == true
          template = Liquid::Template.parse(trigger.condition.gsub('do_work', "#{@drop_object}.do_work"))

          check = template.render(@drop_object => @drop)
          puts "automation template.render check => #{check}"

          check_render_value = check.squish if check.respond_to?(:squish)

          if check_render_value == 'do_work'
            puts "automation template.render check_render_value.length => #{check_render_value.length}"
            wait = trigger.pause && trigger.pause_time.present? ? trigger.pause_time : 1

            trigger.trigger_actions.each do |action|
              attr = action.name.split('#').first

              update_object(attr, action.value) unless action.name.include?('email')

              send_email(attr, action.value, wait) if action.name.include?('email')

              # this is for future create relation object
              # if action.name.include?("create")
              #   create_object(attr, value)
              # end
            end
          end
        end
      end
      puts 'finish automation update'
    end
  end

  def update_object(attr, value)
    hash = {}
    hash[attr] = value
    puts "automation update hash => #{hash}"
    @object.update(hash)
  end

  def send_email(attr, value, wait)
    action_template = Templ.find(value)
    subject_template = Liquid::Template.parse(action_template.subject)
    content_template = Liquid::Template.parse(action_template.content)

    if action_template.receiver == 'client'
      receiver = @object.client.email if @drop_object == 'order'
      receiver = @object.company.main_email if @drop_object == 'incase'
      receiver = @object.company.main_email if @drop_object == 'supply'
    end

    if action_template.receiver == 'user'
      receiver = User.admin_emails if @drop_object == 'incase'
      receiver = User.admin_emails if @drop_object == 'order' # @object.manager.email
      receiver = User.admin_emails if @drop_object == 'supply' # @object.manager.email
    end

    subject = subject_template.render(@drop_object => @drop)
    content = content_template.render(@drop_object => @drop)

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
    # tmpl = Liquid::Template.parse( "{% if incase.strah == 'Альфа' and incase.totalsum == 0 %}{{incase.strah}}{% endif %}")
    check_attributes = Liquid::ParseTreeVisitor.for(tmpl.root).add_callback_for(Liquid::VariableLookup) do |node|
      [node.name, *node.lookups].join('.')
    end.visit.flatten.compact.uniq # => ["incase.strah", "incase.totalsum"]

    # check changes
    check_attributes.each do |attribute|
      object_have_changes.push(@object.saved_change_to_attribute?(attribute.split('.').last))
    end

    object_have_changes.uniq.size == 1 && object_have_changes.uniq.first == true ? true : false
  end

  # this is for future create relation object
  # def create_object(attr, value)
  #   # here attr = "create_supply"
  #   # new_object = attr.remove("create_")
  #   new_object = attr.remove("create_").classify.constantize
  #   if value.present?

  #   end
  # end

end
