class Application::Users::PasswordsController < Devise::PasswordsController
  layout 'no_session'

  protected

  def after_resetting_password_path_for(resource)
    sign_out(resource)
    flash[:notice] = t('views.users.sessions.password_reset')
    notices_path
  end
end
