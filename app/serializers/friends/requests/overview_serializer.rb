module Friends
  module Requests
    class OverviewSerializer < ApiSerializer
      attributes :id, :user, :friend

      def user
        object.user.cached(instance_user, type: :private)
      end

      def friend
        object.friend.cached(instance_user, type: :public)
      end
    end
  end
end
