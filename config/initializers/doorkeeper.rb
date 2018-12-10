Doorkeeper.configure do
  orm :active_record

  resource_owner_authenticator do
    current_api_user || resource_owner_from_credentials
  end

  resource_owner_from_credentials do
    user = User.find_by_email(params[:username])
    user if user && user.valid_password?(params[:password])
  end

  admin_authenticator do
    current_developer || redirect_to(new_developer_session_path)
  end

  access_token_expires_in 1.year
  grant_flows %w(facebook password)
end