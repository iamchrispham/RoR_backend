# frozen_string_literal: true

module Groups
  class OverviewSerializer < ApiSerializer
    attributes :id,
               :type,
               :name,
               :category,
               :acceptance_mode,
               :active,
               :email_domain,
               :location,
               :about,
               :user_id,
               :parent_id,
               :active_members_count,
               :active_friends_count,
               :created_at,
               :images,
               :facebook_profile_link,
               :linkedin_profile_link,
               :instagram_profile_link,
               :snapchat_profile_link,
               :phone,
               :email,
               :website,
               :group_tags,
               :pusher_room_id

    def active_members_count
      object.active_members.count
    end

    def active_friends_count
      object.active_friends.where('friendships.user_id = ?', current_api_user).count
    end

    def contacts
      serialized_resource(object.contacts, ::Contacts::OverviewSerializer)
    end

    def type
      object.class.name
    end

    def pusher_room_id
      object.chat&.chatkit_id
    end
  end
end
