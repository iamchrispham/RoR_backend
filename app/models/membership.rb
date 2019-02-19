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
  after_save :update_user_in_chat_room

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

  def update_user_in_chat_room
    if active?
      ChatkitService.new(user, {room_id: group.chat.chatkit_id}).add_users_to_chat_room
    else
      ChatkitService.new(user, {room_id: group.chat.chatkit_id}).remove_users_from_chat_room
    end
  end
end
