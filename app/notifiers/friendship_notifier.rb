class FriendshipNotifier < Showoff::SNS::Notifier::Base
  belongs_to :friendship

  validates :friendship, uniqueness: true, presence: true

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = friendship
  end

  def self.notification_type
    :friendship_created
  end

  def subscribers
    [friendship.friend]
  end

  def message(target)
    I18n.t('notifiers.friendship.message', user: friend_user(target).name)
  end

  def extra_information(target)
    { user_id: friend_user(target).id }
  end

  def should_notify?(target)
    target.notifications_enabled_for('friendship_created')
  end

  def resources(target)
    { user: friend_user(target).cached(target, type: :public) }
  end

  private

  def friend_user(target)
    friendship.user == target ? friendship.friend : friendship.user
  end
end
