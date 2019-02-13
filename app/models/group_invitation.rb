# frozen_string_literal: true

class GroupInvitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates :group_id, :user_id, presence: true

  validates :user_id,
            uniqueness: {
              scope: :group_id,
              message: 'invitation already exists'
            }

  def status
    active ? :confirmed : :pending
  end
end
