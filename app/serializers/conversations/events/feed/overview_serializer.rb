module Conversations
  module Events
    module Feed
      class OverviewSerializer < ApiSerializer
        attributes :id, :user, :title, :conversation, :updated_at, :event_media_items

        def conversation
          return nil if object.conversation.blank?

          {
            id: object.conversation.id
          }
        end

        def user
          object.user.cached(instance_user, type: :feed)
        end

        def event_media_items
          serialized_resource(object.event_media_items.active, ::Events::MediaItems::OverviewSerializer)
        end
      end
    end
  end
end
