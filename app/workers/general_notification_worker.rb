require 'sidekiq'

class GeneralNotificationWorker
  include Sidekiq::Worker
  include Api::ErrorHelper
  include UserSessionHelper

  sidekiq_options queue: :default, retry: 3

  def perform(general_notification_id)
    notification = GeneralNotification.find_by(id: general_notification_id)
    if notification.present?
      notification.users = User.all
      notification.send_notification
      notification.sent!
    end
  rescue StandardError => e
    report_error(e)
  end
end
