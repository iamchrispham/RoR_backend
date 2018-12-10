class Application::Developers::Developers::PasswordsController < Devise::PasswordsController
  layout 'no_session'

  protected
  def after_sending_reset_password_instructions_path_for(resource_name)
    return new_developer_session_path
  end
end