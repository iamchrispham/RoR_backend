class Application::Users::ConfirmationsController < Devise::ConfirmationsController
  layout 'no_session'

  protected
  def after_confirmation_path_for(resource_name, resource)
    sign_out(resource)
    flash[:notice] = t('views.users.confirmations.confirmed')
    notices_path
  end
end
