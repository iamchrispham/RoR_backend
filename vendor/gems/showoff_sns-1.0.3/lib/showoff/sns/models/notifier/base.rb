module Showoff
  module SNS
    module Notifier
      class Base < ActiveRecord::Base
        self.abstract_class = true

        include Showoff::Helpers::CurrentAPIUserHelper
        include Showoff::Helpers::SerializationHelper

        belongs_to :notification, foreign_key: 'showoff_sns_notification_id', class_name: 'Showoff::SNS::Notification', dependent: :destroy
        belongs_to :owner, polymorphic: true

        validates :notification, uniqueness: true, presence: true
        validates :owner, presence: true

        before_validation :set_owner, on: :create
        before_validation :create_notification, on: :create, if: 'notification.nil?'

        def set_owner
          # Define your notification owner here
          raise NotImplementedError, 'You must define a notifier owner'
        end

        def self.notification_type
          # Define your notification type here
          raise NotImplementedError, 'You must define a notification type'
        end

        def should_notify?(_target)
          true
        end

        def subscribers
          # Define your notification subscribers here
          raise NotImplementedError, 'You must define a set of subscribers for your notification'
        end

        def message(_target)
          # Define your notification message here
          raise NotImplementedError, 'You must define a message for your notification'
        end

        def extra_information(_target)
          # Define your notification extra information here
          raise NotImplementedError, 'You must define extra information for your notification'
        end

        def resources(_target)
          {}
        end

        def modifiable?
          notification.modifiable?
        end

        def send_notification
          notification.update_attributes(notifier: self)
          notification.send_notification
        end
      end
    end
  end
end
