class Ability

  include CanCan::Ability

  def initialize(user, cname) # cname из aplication controller для определения Модели
		alias_action :index, :show, :to => :read
		alias_action :new, :to => :create
		alias_action :edit, :to => :update
		alias_action :delete_selected, :to => :destroy
    # Define abilities for the passed in user here. For example:
    user ||= User.new # guest user (not logged in)
    # puts "user role - "+"#{user.role}"
    if user.role == "admin"
      can :manage, :all
    else
      user.permissions.each do |permission|
        model = permission.pmodel.constantize
        if permission.pactions.present?
          permission.pactions.each do |action|
            action = action.to_sym
            puts "#{action}"+" - "+"#{model}" if cname == model
            can :read, :all if model == cname
            can action, model
          end
        end
      end
    end
  end

end
