class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if:  :devise_controller?
  before_action :authenticate_user!

    rescue_from CanCan::AccessDenied do |exception|
      puts "CanCan::AccessDenied message => " + exception.message.to_s
      puts "CanCan::AccessDenied action => " + exception.action.to_s
      puts "CanCan::AccessDenied subject => " + exception.subject.to_s
      flash[:notice] = "#{exception.message} #{exception.action}--#{exception.subject}"
      redirect_to root_url
    end


    private

    def after_sign_in_path_for(resource_or_scope)
      dashboards_path
    end # after_sign_in_path_for
  
    def after_sign_out_path_for(resource_or_scope)
      root_path
    end

    def current_ability
      cname = controller_name.classify.constantize
      @current_ability ||= Ability.new(current_user, cname)
    end

    def write_audit(attrs)
      attrs[:associated_type] = record_type
      attrs[:associated_id] = record_id
      super
    end

    protected

    def configure_permitted_parameters
      attributes = [:name, :email]
      devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    end
    

end
