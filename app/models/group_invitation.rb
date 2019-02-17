# frozen_string_literal: true

class GroupInvitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  enum status: [:pending, :accepted, :rejected]

  has_one :group_invitation_notifier, dependent: :destroy
  after_commit :create_group_invitation_notifier, on: :create

  validates :group_id, :user_id, presence: true

  validates :user_id,
            uniqueness: {
              scope: :group_id,
              message: 'invitation already exists'
            }

  def accept!
    accepted!
    group.memberships.create(user_id: user_id).activate
  end

  def reject!
    rejected!
  end
end
