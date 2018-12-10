module Showoff
  module API
    module Doc
      module BearerAuthentication
        def self.included(base)
          base.instance_eval do
            header :bearer, 'Bearer token', required: true
            error ::Showoff::API::ResponseCodes::STATUS[::Showoff::API::ResponseCodes::NO_AUTHENTICATED_USER], 'Unauthorized'
          end
        end
      end
    end
  end
end
