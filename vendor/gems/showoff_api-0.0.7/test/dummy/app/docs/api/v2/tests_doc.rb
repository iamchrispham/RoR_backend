module Api
  module V2
    module TestsDoc
      extend Showoff::API::Doc::Base
      resource :tests

      defaults do
        auth_with_bearer
      end

      doc_for :index do
        api :GET, api_endpoint_base, 'Get a list of third party services (V2)'
      end
    end
  end
end
