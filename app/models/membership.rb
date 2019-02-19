# frozen_string_literal: true

class Membership < ActiveRecord::Base
  include Indestructable

  after_create :add_user_to_chat_room

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

  def add_user_to_chat_room
    ChatkitService.new(user_id).add_users_to_room(group.chat.chatkit_id)
  end
end
