module Events
  module Timelines
    module Items
      class OverviewSerializer < ApiSerializer
        attributes :id, :user, :media_items, :liked, :number_of_likes, :number_of_comments, :comments, :event

        def user
          object.user.cached(instance_user, type: :feed)
        end

        def media_items
          serialized_resource(object.media_items.active, ::Events::Timelines::Items::MediaItems::OverviewSerializer, user: instance_user)
        end

        def liked
          EventTimelineItemLike.exists?(user: instance_user, event_timeline_item: object)
        end

        def comments
          comments = object.event_timeline_item_comments.active.includes(:user).order(created_at: :desc).limit(2)
          serialized_resource(comments, ::Events::Timelines::Items::Comments::OverviewSerializer, user: instance_user)
        end

        def event
          serialized_resource(object.event, ::Events::Feed::Minified::OverviewSerializer, user: instance_user)
        end
      end
    end
  end
end
