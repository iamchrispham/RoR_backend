# TODO: Remove this in favour of notifier.

module Showoff
  module SNS
    class Notification < ActiveRecord::Base
      self.table_name = :showoff_sns_notifications

      has_many :notified_objects, foreign_key: :showoff_sns_notification_id, class_name: 'Showoff::SNS::NotifiedObject', dependent: :destroy
      belongs_to :notifier, polymorphic: true

      enum status: [:pending, :sending, :sent, :failed, :delivered]

      # attribute_name and attribute_ids are used to filter the devices that
      # this notification will be sent to. EG if you have devices added on a
      # per Vendor basis, then the notifier should define the attribute name
      # as vendor_id and the attribute_id as the vendor to send notifications to

      def attribute_name
        notifier.attribute_name if notifier.respond_to?(:attribute_name)
      end

      def attribute_ids
        notifier.attribute_ids if notifier.respond_to?(:attribute_ids)
      end

      def modifiable?
        !unmodifiable?
      end

      def unmodifiable?
        sending? || sent? || failed?
      end

      def send_notification
        if pending? || failed?
          self.status = :sending
          Showoff::SNS::NotificationWorker.perform_async(id, attribute_name, attribute_ids)
        end
      end

      def status
        @status = :pending if pending?
        @status = :failed if failed?
        @status = :sent if sent?
        @status = :sending if sending?
        @status
      end

      def set_status(status)
        self.status = status
        notified_objects.update_all(status: Showoff::SNS::NotifiedObject.statuses[status.to_s])
      end
    end
  end
end
