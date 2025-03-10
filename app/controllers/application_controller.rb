class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :set_current_user

  rescue_from CanCan::AccessDenied do |exception|
    puts "CanCan::AccessDenied message => #{exception.message}"
    puts "CanCan::AccessDenied action => #{exception.action}"
    puts "CanCan::AccessDenied subject => #{exception.subject}"
    msg = "#{exception.message} #{exception.action}--#{exception.subject}"
    # flash[:notice] = msg
    # redirect_to root_url # redirect_to(request.referrer || root_path)

    flash.now[:notice] = msg
    render turbo_stream: [
      render_turbo_flash
    ]
  end

  def render_turbo_flash
    turbo_stream.update('our_flash', partial: 'shared/flash')
  end

  private

  def after_sign_in_path_for(resource_or_scope)
    dashboards_path
  end

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

  def set_current_user
    User.current = current_user
  end

  protected

  def configure_permitted_parameters
    attributes = %i[name email]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
  end

end
