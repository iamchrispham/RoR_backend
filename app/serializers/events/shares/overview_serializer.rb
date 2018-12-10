module Events
  module Shares
    class OverviewSerializer < ApiSerializer
      attributes :id, :user, :event, :users

      def user
        object.user.cached(instance_user, type: :feed)
      end

      def event
        object.event.cached(instance_user, type: :feed)
      end

      def users
        return [] if instance_options[:exclude_users]
        object.users.map { |user| user.cached(instance_user, type: :feed) }
      end
    end
  end
end
