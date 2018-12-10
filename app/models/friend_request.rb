class FriendRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: :friend_id

  has_one :friend_request_notifier, dependent: :destroy
  after_commit :create_friend_request_notifier, on: :create

  validates :user, presence: true
  validates :friend, presence: true, uniqueness: { scope: :user }
  validate :not_self
  validate :not_pending

  scope :requested_for_user, -> (user) { where(friend_id: user.id) }

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
    friend&.update_caches
  end

  def accept
    user.friends << friend
    destroy
  end

  private

  def not_self
    errors.add(:friend, "cannot be you. You cannot befriend yourself") if user == friend
  end

  def not_pending
    errors.add(:friend, 'already requested friendship') if friend.pending_friends.include?(user)
  end
end
