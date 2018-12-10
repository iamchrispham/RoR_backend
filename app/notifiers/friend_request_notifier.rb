class FriendRequestNotifier < Showoff::SNS::Notifier::Base

  belongs_to :friend_request

  validates :friend_request, uniqueness: true, presence: true

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = friend_request.user
  end

  def self.notification_type
    :friend_request
  end

  def subscribers
    [friend_request.friend]
  end

  def message(_target)
    I18n.t('notifiers.friend_request.message', user: friend_request.user.name)
  end

  def extra_information(_target)
    { friend_request_id: friend_request.id }
  end

  def should_notify?(target)
    target.notifications_enabled_for('friend_request')
  end

  def resources(target)
    { friend_request: serialized_resource(friend_request, ::Friends::Requests::OverviewSerializer, user: target) }
  end
end
