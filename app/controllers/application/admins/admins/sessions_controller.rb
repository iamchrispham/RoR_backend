class Application::Admins::Admins::SessionsController < Devise::SessionsController
  layout 'no_session'

  def new
    self.resource = resource_class.new(sign_in_params)
    store_location_for(resource, params[:redirect_to])
    sign_out_all_admins
    flash.keep
    super
  end

  protected
  def after_sign_in_path_for(resource)
    sign_in_url = new_admin_session_url
    if request.referer == sign_in_url
      admin_dashboard_url
    else
      stored_location_for(resource) || admin_dashboard_url
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path
  end

  def sign_out_all_admins
    if current_admin.present? || current_developer.present?
      sign_out_all_scopes
    end
  end
end