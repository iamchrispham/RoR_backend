class Application::Developers::Developers::SessionsController < Devise::SessionsController
  layout 'no_session'

  def new
    sign_out_all_admins
    flash.keep
    super
  end

  def after_sign_out_path_for(resource_or_scope)
    new_developer_session_path
  end

  def sign_out_all_admins
    if current_admin.present? || current_developer.present?
      sign_out_all_scopes
    end
  end
end