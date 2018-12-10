class NotificationSetting < ActiveRecord::Base
  validates :name, :description, :slug, presence: true

  has_many :notification_setting_user_notification_settings, dependent: :destroy
  has_many :user_notification_settings, through: :notification_setting_user_notification_settings
end
