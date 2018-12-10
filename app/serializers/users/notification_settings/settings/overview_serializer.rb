module Users
  module NotificationSettings
    module Settings
      class OverviewSerializer < ApiSerializer
        attributes :id, :notification_setting, :enabled

        def notification_setting
          serialized_resource(object.notification_setting, ::NotificationSettings::OverviewSerializer)
        end
      end
    end

  end
end
