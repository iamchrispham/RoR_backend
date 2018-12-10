class Application::Admins::Admins::PasswordsController < Devise::PasswordsController
  layout 'no_session'

  protected
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_admin_session_path
  end

  def after_resetting_password_path_for(resource)
    admin_dashboard_url
  end
end