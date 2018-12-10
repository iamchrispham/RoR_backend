module Api
  module V1
    module Feed
      class FeedController < ApiController
        def index
          success_response(feed: serialized_resource(current_api_user.subscribed_feed_items.active.includes([:feed_item_context, :object]).limit(limit).offset(offset), ::Feeds::Items::OverviewSerializer, user: current_api_user))
        end
      end
    end
  end
end
