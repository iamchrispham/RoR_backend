module Users
  module Feed
    class OverviewSerializer < ApiSerializer
      attributes :id, :name, :images, :attending_event_count, :event_count, :friend, :friend_request_pending, :pending_friend_request

      def attending_event_count
        object.attending_events.where.not(user: object).active.count
      end

      def event_count
        object.hosting_events.active.count
      end

      def friend
        false
      end

      def friend_request_pending
        false
      end

      def pending_friend_request
        nil
      end
    end
  end
end
