module Events
  module Attendees
    class OverviewSerializer < ApiSerializer
      attributes :id, :status, :user, :contribution, :request, :updated_at

      def user
        return nil if instance_options[:exclude_user].present?
        object.user.cached(instance_user, type: :feed)
      end

      def contribution
        serialized_resource(object.contribution, ::Events::Contributions::OverviewSerializer, user: instance_user)
      end

      def request
        serialized_resource(object.event_attendee_request, ::Events::Attendees::Requests::OverviewSerializer, user: instance_user)
      end
    end
  end
end
