module Feeds
  module Contexts
    class OverviewSerializer < ApiSerializer
      attributes :id, :message, :action, :actor, :actor_type, :updated_at

      def action
        serialized_resource(object.feed_item_action, ::Feeds::Actions::OverviewSerializer, user: instance_user)
      end

      def actor
        if object.actor.is_a?(User)
          object.actor.cached(object.actor, type: :feed)
        else
          serialized_resource(object.actor, object.actor.actor_serializer, user: instance_user)
        end
      end
    end
  end
end
