require 'sidekiq'

module Showoff
  module SNS
    class NotificationWorker
      include Sidekiq::Worker
      sidekiq_options queue: Showoff::SNS.configuration.queue.to_sym, retry: 3

      def perform(notification_id, attribute_name = nil, attribute_ids = nil)
        notification = Showoff::SNS::Notification.find_by(id: notification_id)
        if notification
          notifier = notification.notifier

          begin
            notification.status = :sending
            notification.save

            client = Showoff::SNS.client
            subscribers = notifier.subscribers

            if subscribers.count > 0
              notified_subscribers = 0

              subscriber_loop_type = subscribers.is_a?(Array) ? :each : :find_each
              subscribers.send(subscriber_loop_type) do |subscriber|
                if notifier.should_notify?(subscriber)
                  if subscriber.active_devices.count > 0 && subscriber.notifications_enabled
                    device_pool = subscriber.active_devices
                    device_pool = device_pool.where(attribute_name.to_sym => attribute_ids) if attribute_name

                    device_pool.find_each do |device|
                      extra_information = {
                        uuid: device.uuid,
                        type: notifier.class.notification_type,
                        notification_id: notification.id
                      }
                      notifier_information = notifier.extra_information(subscriber)
                      extra_information = extra_information.merge(notifier_information) if notifier_information
                      client.notify(device, notifier.message(subscriber), extra_information)
                    end
                  end

                  notified_subscribers += 1
                  notification.notified_objects.create(notifiable: subscriber, owner: notifier.owner)
                end
              end

              notification.subscriber_count = notified_subscribers
              Rails.logger.info "Sent to #{notification.subscriber_count} subscribers."
              notification.set_status(:sent)
            else
              notification.set_status(:delivered)
            end
            notification.sent_at = Time.now
          rescue => e
            notification.set_status(:failed)
            Rails.logger.error e.inspect
            raise e
          ensure
            notification.save
          end
        end
      end
    end
  end
end
