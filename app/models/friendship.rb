class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  has_one :friendship_notifier, dependent: :destroy

  validates :user, presence: true
  validates :friend, presence: true, uniqueness: { scope: :user }
  validate :not_self

  after_create :create_inverse_relationship
  after_create :increment_totals
  after_commit :create_friendship_notifier, on: :create

  before_destroy :decrement_totals
  before_destroy :deactivate_feed_items_if_required

  after_destroy :destroy_inverse_relationship

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
    friend&.update_caches
  end

  def deactivate_feed_items_if_required
    user.user_feed_items_for_friend(friend.id).destroy_all
    friend.user_feed_items_for_friend(user.id).destroy_all
  end

  private

  def create_inverse_relationship
    friend.friendships.create(friend: user)
  end

  def destroy_inverse_relationship
    friendship = friend.friendships.find_by(friend: user)
    friendship.destroy if friendship
  end

  def increment_totals
    user.update_attributes(friend_count: user.friend_count + 1)
    friend.update_attributes(friend_count: friend.friend_count + 1)
  end

  def decrement_totals
    user.update_attributes(friend_count: user.friend_count - 1 < 0 ? 0 : user.friend_count - 1)
    friend.update_attributes(friend_count: friend.friend_count - 1 < 0 ? 0 : friend.friend_count - 1)
  end

  def not_self
    errors.add(:friend, "can't be equal to user") if user == friend
  end
end
