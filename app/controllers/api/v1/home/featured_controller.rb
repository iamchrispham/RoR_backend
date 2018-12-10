module Api
  module V1
    module Home
      class FeaturedController < ApiController
        def create
          success_response(events)
        end

        private

        def events
          results, index = featured_objects(
            current_api_user.applicable_events,
            params,
            nil,
            limit,
            offset,
            current_api_user
          )
          {
            meta: {
              offset: index
            },
            objects: results
          }
        end
      end
    end
  end
end
