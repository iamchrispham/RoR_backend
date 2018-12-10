module Showoff
  module SNS
    class Notification
      class Serializer < ActiveModel::Serializer
        include Showoff::Helpers::CurrentAPIUserHelper
        include Showoff::Helpers::SerializationHelper

        attributes :id, :message, :status, :created_at, :notification_type, :resources

        def notification_type
          object.notifier.class.notification_type
        end

        def message
          object.notifier.message(instance_options[:user])
        end

        def status
          notified_object = object.notified_objects.find_by(notifiable: instance_options[:notifiable])
          notified_object ? notified_object.status : 'unknown'
        end

        def resources
          object.notifier.resources(instance_options[:user])
        end
      end
    end
  end
end
