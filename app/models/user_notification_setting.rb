class UserNotificationSetting < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true

  after_save :ensure_has_all_notification_settings

  has_many :notification_setting_user_notification_settings, dependent: :destroy
  has_many :notification_settings, through: :notification_setting_user_notification_settings

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
  end

  private
  def ensure_has_all_notification_settings
    if notification_settings.count < NotificationSetting.count
      missing_notification_settings = NotificationSetting.where.not(id: notification_settings)
      missing_notification_settings.each do |notification_setting|
        notification_setting_user_notification_settings << NotificationSettingUserNotificationSetting.create(
            user_notification_setting: self,
            notification_setting: notification_setting
        )
      end
    end
  end
end
