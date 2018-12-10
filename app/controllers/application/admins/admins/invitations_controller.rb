class Application::Admins::Admins::InvitationsController < Devise::InvitationsController
  layout 'no_session'

  def edit
    if not resource.active?
      redirect_to root_url
    else
      super
    end

  end
end