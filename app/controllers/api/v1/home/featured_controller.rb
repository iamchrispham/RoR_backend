module Api
  module V1
    module Home
      class FeaturedController < ApiController
        skip_before_filter :doorkeeper_authorize!

        def create
          results = featured_objects(Event.not_private.approved_business_events, params, nil, limit, offset, nil)
          success_response(meta: {offset: results.size}, objects: results)
        end
      end
    end
  end
end
