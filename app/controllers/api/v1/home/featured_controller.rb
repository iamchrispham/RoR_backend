module Api
  module V1
    module Home
      class FeaturedController < ApiController
        skip_before_filter :doorkeeper_authorize!

        def create
          if current_api_user.present?
            success_response(token_events)
          else
            success_response(non_token_events)
          end
        end

        private
        def token_events
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

        def non_token_events
          results, index = featured_objects(
              Event.not_private,
              params,
              nil,
              limit,
              offset,
              nil
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
