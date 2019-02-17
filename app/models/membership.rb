# frozen_string_literal: true

class Membership < ActiveRecord::Base
  include Indestructable

  belongs_to :user
  belongs_to :group
  has_one :group_membership_notifier, dependent: :destroy

  validates :user_id,
            uniqueness: {
              scope: %i[group_id],
              message: 'has group membership'
            }

  after_save :send_notifications

  def status
    return :active if active

    :pending
  end

  private

  def send_notifications
    if active? && %w[college society].include?(group.category)
      create_group_membership_notifier
    end
  end
end
