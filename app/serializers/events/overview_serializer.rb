module Events
  class OverviewSerializer < ApiSerializer
    attributes :id, :user, :title, :description, :time, :date, :eighteen_plus, :price,
               :reported, :attendance, :attendee_count, :mutual_attendee_count, :mutual_attendees, :conversation,
               :location, :categories, :bring, :address, :country, :private_event,
               :tags, :categories, :event_forwarding, :allow_chat, :show_timeline, :maximum_attendees, :attendance_acceptance_required,
               :bring, :active, :event_contribution_detail, :event_ticket_detail, :event_media_items, :attendees, :related_events, :updated_at

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
      attendees = object.event_attendees

      attendees.valid.count
    end

    def mutual_attendee_count
      object.mutual_event_attendees(instance_user).count
    end

    def mutual_attendees
      object.mutual_event_attendees(instance_user).limit(2).map { |user| user.cached(instance_user, type: :feed) }
    end

    def user
      object.user.cached(instance_user, type: :public)
    end

    def country
      serialized_resource(object.country_object, ::Countries::OverviewSerializer)
    end

    def currency
      serialized_resource(object.currency, ::Countries::Currencies::OverviewSerializer)
    end

    def event_contribution_detail
      nil
    end

    def event_ticket_detail
      nil
    end

    def event_media_items
      serialized_resource(object.event_media_items.active, ::Events::MediaItems::OverviewSerializer)
    end

    def related_events
      object.related_events.map { |event| event.cached(instance_user, type: :feed) }
    end

    def reported
      Report.exists?(reporter: instance_user, reportable: object)
    end

    def attendance
      serialized_resource(object.event_attendees.where(user: instance_user).first, ::Events::Attendees::OverviewSerializer, exclude_user: true, user: instance_user)
    end

    def attendees
      attendees = object.event_attendees

      serialized_resource(attendees.valid.joins(:user).where.not(user: instance_user).order("users.business_name ASC, users.first_name || ' ' || users.last_name ASC").limit(10), ::Events::Attendees::OverviewSerializer, exclude_user: false, user: instance_user)
    end
  end
end
