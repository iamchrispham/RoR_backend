module Companies
  class OverviewSerializer < ApiSerializer
    attributes :id, :type, :images, :event_count, :attending_event_count, :user_id, :title, :description, :phone_number, :email, :facebook_profile_link, :linkedin_profile_link, 
               :instagram_profile_link, :snapchat_profile_link, :website_link, :location, :categories, :attending_event_count, :shared, :invited,
               :friend_request_pending, :pending_friend_request, :friend

    def type
      object.class.name
    end

    def event_count
      object.hosting_events.starting_at_or_after(Time.now).active.count
    end

    def shared
      false
    end

    def invited
      false
    end

    def friend_request_pending
      false
    end

    def pending_friend_request
      nil
    end

    def friend
      false
    end

    def attending_event_count
      nil
    end
  end
end