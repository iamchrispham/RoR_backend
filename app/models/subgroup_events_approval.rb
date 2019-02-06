# frozen_string_literal: true

class SubgroupEventsApproval < ActiveRecord::Base
  include Indestructable

  belongs_to :group
  belongs_to :subgroup, class_name: 'Group'
  belongs_to :event
  belongs_to :user

  validates :event_id,
            uniqueness: {
              scope: %i[group_id subgroup_id],
              message: 'request already sent'
            }

  def status
    return :approved if active

    :pending
  end
end
