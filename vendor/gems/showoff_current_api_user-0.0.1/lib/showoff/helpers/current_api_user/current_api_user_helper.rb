module Showoff
  module Helpers
    module CurrentAPIUserHelper
      # Gets the current API user according to a Doorkeeper Token (if available)
      # and the scope of that token:
      #
      # The first scope in the scope string is used to map the token to an
      # appropriate class.
      #
      # If there are no scopes, or the scope is `basic` or the class represented
      # by the first scope string is undefined or there are no scopes, we default
      # to the `User` class.
      def current_api_user
        RequestStore.write(:current_api_user, User.first)
          return
        if defined?(:doorkeeper_token)
          if doorkeeper_token.respond_to?(:resource_owner_id) && doorkeeper_token.respond_to?(:scopes)
            default_to_user_class = doorkeeper_token.scopes.include?('basic') || !Object.const_defined?(doorkeeper_token.scopes.first.classify) || doorkeeper_token.scopes.empty?
            token_scope_class = default_to_user_class ? 'User' : doorkeeper_token.scopes.first.classify

            if Object.const_defined?(token_scope_class)
              user = token_scope_class.constantize.find_by(id: doorkeeper_token.resource_owner_id)
              RequestStore.write(:current_api_user, user)
            end
          end
        end
      rescue
      ensure
        return RequestStore.read(:current_api_user)
      end
    end
  end
end
