# frozen_string_literal: true

class GroupSubgroupApproval < ActiveRecord::Base
  include Indestructable

  belongs_to :group
  belongs_to :subgroup, class_name: 'Group'
  belongs_to :user

  validates :subgroup_id, :group_id, :user_id, presence: true

  validates :subgroup_id,
            uniqueness: {
              scope: %i[group_id],
              message: 'request already sent'
            }

  def status
    return :approved if active

    :pending
  end
end
