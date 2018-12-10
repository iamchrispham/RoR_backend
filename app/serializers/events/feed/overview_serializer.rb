module Events
  module Feed
    class OverviewSerializer < ApiSerializer
      attributes :id, :user, :title, :time, :date, :eighteen_plus, :event_forwarding, :allow_chat, :show_timeline,
                 :reported, :conversation, :attendance, :attendee_count, :mutual_attendee_count, :mutual_attendees,
                 :maximum_attendees, :attendance_acceptance_required,
                 :location, :address, :private_event, :event_media_items, :updated_at

      def conversation
        return nil if object.conversation.blank?

        {
          id: object.conversation.id
        }
      end

      def address
        object.public_address
      end

      def attendee_count
        object.event_attendees.going.count
      end

      def mutual_attendee_count
        0
      end

      def mutual_attendees
        []
      end

      def user
        object.user.cached(instance_user, type: :feed)
      end

      def event_media_items
        serialized_resource(object.event_media_items.active, ::Events::MediaItems::OverviewSerializer)
      end

      def reported
        false
      end

      def attendance
        nil
      end
    end
  end
end
