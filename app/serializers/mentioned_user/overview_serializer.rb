class MentionedUser
  class OverviewSerializer < ApiSerializer
    attributes :user_id, :username, :start_index, :end_index

    def user_id
      object.mentioned_user.id
    end

    def name
      object.mentioned_user.name
    end
  end
end
