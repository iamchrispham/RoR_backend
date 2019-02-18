module Api
  module V1
    module Home
      class FeaturedController < ApiController
        skip_before_filter :doorkeeper_authorize!

        def create
          results, index = featured_objects(Event.not_private.approved_business_events, params, nil, limit, offset, nil)
          success_response(meta: {offset: index}, objects: results)
        end
      end
    end
  end
end
