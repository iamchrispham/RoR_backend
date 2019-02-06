# frozen_string_literal: true

module Groups
  class SubgroupEventApprovalSerializer < ApiSerializer
    attributes :id,
               :event_id,
               :group_id,
               :subgroup_id,
               :user_id,
               :status
  end
end
