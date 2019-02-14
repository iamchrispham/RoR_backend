module Users
  class PublicSerializer < ApiSerializer
    attributes :id, :type, :name, :images, :cover_images, :first_name, :last_name, :description,
               :identification, :user_type, :business_name, :friend_count, :mutual_friends_count,
               :event_count, :attending_event_count, :friend, :friend_request_pending, :pending_friend_request,
               :shared, :invited, :facebook_profile_link, :linkedin_profile_link, :instagram_profile_link,
               :snapchat_profile_link
    def type
      object.class.name
    end

    def identification
      nil
    end

    def friend_count
      object.friends.count
    end

    def shared
      false
    end

    def invited
      false
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

    def attending_event_count
      object.attending_events.where.not(event_ownerable: object).starting_at_or_after(Time.now).active.count
    end

    def event_count
      object.hosting_events.starting_at_or_after(Time.now).active.count
    end

    def mutual_friends_count
      0
    end
  end
end
