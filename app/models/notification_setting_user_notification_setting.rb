class NotificationSettingUserNotificationSetting < ActiveRecord::Base
  belongs_to :user_notification_setting
  belongs_to :notification_setting

  validates :user_notification_setting, :notification_setting, presence: true
end
