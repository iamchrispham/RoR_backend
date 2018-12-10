class UserFacebookEventImportNotifier < Showoff::SNS::Notifier::Base
  belongs_to :user_facebook_event_import

  validates :user_facebook_event_import, uniqueness: true, presence: true

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = user_facebook_event_import.user
  end

  def self.notification_type
    :user_facebook_event_import
  end

  def subscribers
    [user_facebook_event_import.user]
  end

  def message(_target)
    I18n.t('notifiers.user_facebook_event_import.generic.message')
  end

  def extra_information(_target)
    { user_facebook_event_import_id: user_facebook_event_import.id }
  end

  def should_notify?(target)
    target.notifications_enabled_for('facebook_event_import')
  end

  def resources(target)
    { user_facebook_event_import: serialized_resource(user_facebook_event_import, ::Events::Imports::Facebook::OverviewSerializer, user: target) }
  end
end
