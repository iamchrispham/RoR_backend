# frozen_string_literal: true

module Groups
  class MembershipSerializer < ApiSerializer
    attributes :id,
               :user_id,
               :group_id,
               :status
  end
end
