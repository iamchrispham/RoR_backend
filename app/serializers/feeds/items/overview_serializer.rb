module Feeds
  module Items
    class OverviewSerializer < ApiSerializer
      attributes :id, :context, :type, :event, :media, :updated_at

      def media
        serialized_resource(object.media, ::Events::Timelines::Items::OverviewSerializer, user: instance_user)
      end

      def event
        object.event&.cached(instance_user, type: :feed) || nil
      end

      def context
        serialized_resource(object.context, ::Feeds::Contexts::OverviewSerializer, user: instance_user)
      end
    end
  end
end
