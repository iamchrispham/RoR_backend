module Users
  module NotificationSettings
    class OverviewSerializer < ApiSerializer
      attributes :id, :settings

      def settings
        serialized_resource(
            object.notification_setting_user_notification_settings.joins(:notification_setting).order('notification_settings.name asc'),
            ::Users::NotificationSettings::Settings::OverviewSerializer
        )
      end



    end
  end
end
