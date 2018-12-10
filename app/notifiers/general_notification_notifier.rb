class GeneralNotificationNotifier < Showoff::SNS::Notifier::Base
  belongs_to :general_notification
  validates :general_notification, presence: true

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = general_notification.owner
  end

  def self.notification_type
    :general
  end

  def subscribers
    general_notification.users
  end

  def message(_target)
    general_notification.message
  end

  def extra_information(_target)
    {}
  end

  def should_notify?(target)
    target.notifications_enabled_for('general')
  end

  def resources(target)
    {
        target_mode: target_mode(target),
        platform: serialized_resource(general_notification.platform, ::Platforms::PublicSerializer),
        general_notification: serialized_resource(general_notification, ::GeneralNotifications::OverviewSerializer, user: target)
    }
  end

  def target_mode(_target)
    general_notification.target_mode
  end
end
