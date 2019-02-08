# frozen_string_literal: true

module Groups
  class GroupSubgroupApprovalSerializer < ApiSerializer
    attributes :id,
               :group_id,
               :subgroup_id,
               :user_id,
               :status
  end
end
