# frozen_string_literal: true

module Api
  module DoorkeeperHelper
    def ensure_current_api_user_owns(resource, resource_owner = :user)
      if resource.respond_to?(resource_owner) && current_api_user.id.eql?(resource.send(resource_owner).id)
        yield
      else
        unauthorized_response
      end
    end

    def valid_client
      set_client_from_params

      return false unless @client

      true
    end

    def create_access_token(user)
      set_client_from_params
      set_scopes

      get_access_token(user)
    end

    def create_temporary_access_token(user)
      set_client_from_params
      set_scopes

      get_access_token(user, 1.hour)
    end

    def set_client_from_params
      @client = Doorkeeper::Application.by_uid_and_secret params[:client_id],
                                                          params[:client_secret]
    end

    def set_scopes
      @scopes ||= (params[:scope] || params[:scopes] || 'basic')
    end

    def generate_token_with_revoke_for_new_credentials(user)
      @client = doorkeeper_token.application

      revoke_all_tokens(user)
      get_access_token(user)
    end

    def generate_token_from_temporary_access_token(user)
      @client = doorkeeper_token.application
      doorkeeper_token&.revoke
      get_access_token(user)
    end

    def revoke_all_tokens(user)
      tokens = Doorkeeper::AccessToken.where(resource_owner_id: user.id)
      tokens.each(&:revoke)
    end

    def get_access_token(user, expires_in = Doorkeeper.configuration.access_token_expires_in)
      Doorkeeper::AccessToken.create!(
        application_id: @client.id,
        resource_owner_id: user.id,
        scopes:  set_scopes.to_s,
        expires_in: expires_in.to_i,
        use_refresh_token: Doorkeeper.configuration.refresh_token_enabled?
      )
    end

    def access_token_body(token)
      {
        token: base_access_token_body(token)
      }
    end

    def base_access_token_body(token)
      {
        access_token: token.token,
        token_type: token.token_type,
        expires_in: token.expires_in_seconds,
        refresh_token: token.refresh_token,
        scope: token.scopes_string,
        created_at:  token.created_at.to_i
      }
    end
  end
end
