require 'doorkeeper/oauth/helpers/scope_checker'
module Api
  class TokenController < Doorkeeper::TokensController
    include Api::ResponseHelper
    include Api::DoorkeeperHelper
    include UserSessionHelper

    def create
      store_request_in_thread

      token_generator = TokenGenerationService.new(params)
      case params[:grant_type]
      when 'facebook'
        @token = token_generator.generate_for_facebook_user
      when 'password'
        @token = token_generator.generate_for_natural_user(strategy)
      end

      if token_generator.errors.nil?
        token = access_token_body(@token)
        response_data = token

        if token_generator.suggest_account_merge
          response_data[:merge] = true
          response_data[:message] = I18n.t('api.responses.oauth.facebook.merge')
        end

        record_login(User.find_by(id: doorkeeper_token.resource_owner_id), doorkeeper_token)

        facebook_merge_response(response_data)
      else
        error = token_generator.errors.first
        error_response(error[:message], error[:type])
      end
    rescue Doorkeeper::Errors::DoorkeeperError => e
      handle_token_exception e
    end

    def revoke
      post_token = request.POST['token']
      if doorkeeper_token && doorkeeper_token.accessible?

        token = Doorkeeper::AccessToken.by_token(post_token) || Doorkeeper::AccessToken.by_refresh_token(post_token)
        @user = User.find(token.resource_owner_id)
        if @user
          revoked = revoke_token(post_token) if post_token

          if revoked
            device = @user.devices.find_by(push_token: params[:push_token])
            device.update_attributes(active: false) if device
          end
          success_response(message: I18n.t('api.responses.oauth.token.revoked'))
        else
          error_response(I18n.t('api.responses.users.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end
      else
        error_response(I18n.t('api.responses.oauth.token.invalid'), Showoff::ResponseCodes::INVALID_ARGUMENT)
      end
    end

    private

    def revoke_token(token)
      token = Doorkeeper::AccessToken.by_token(token) || Doorkeeper:: AccessToken.by_refresh_token(token)
      if token && doorkeeper_token.same_credential?(token)
        token.revoke
        true
      else
        false
      end
    end
  end
end
