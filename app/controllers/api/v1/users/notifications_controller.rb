module Api
  module V1
    module Users
      class NotificationsController < ApiController
        def index
          notifications = current_api_user.notifications.where.not(notifier_type: 'Conversations::MessageSentNotifier')
          if params[:status]
            status_notifications = (params[:status] + '_notifications').to_sym
            notifications = current_api_user.send(status_notifications) if current_api_user.respond_to?(status_notifications)
          end

          @paginated_notifications = notifications.order(created_at: :desc).limit(params[:limit]).offset(params[:offset])

          success_response(notifications: serialized_resource(@paginated_notifications, Showoff::SNS::Notification::Serializer, notifiable: current_api_user, user: current_api_user))
        end

        def update
          notification = Showoff::SNS::Notification.find_by(id: params[:id])
          if notification
            notification.update_attributes(status: Showoff::SNS::Notification.statuses[:delivered])
            updated_status = Showoff::SNS::NotifiedObject.statuses[params[:status]]
            if updated_status
              notified_object = current_api_user.notified_objects.find_by(notification: notification)

              if notified_object
                notified_object.update_attributes(status: params[:status])
                success_response(status_updated: true)
              else
                error_response(t('api.responses.notifications.invalid_notification'), Showoff::ResponseCodes::INVALID_ARGUMENT)
              end
            else
              error_response(t('api.responses.notifications.invalid_status'), Showoff::ResponseCodes::INVALID_ARGUMENT)
            end
          else
            error_response(t('api.responses.notifications.not_found'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          end
        end
      end
    end
  end
end
