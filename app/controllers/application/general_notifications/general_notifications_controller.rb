module Application
  module GeneralNotifications
    class GeneralNotificationsController < WebController
      before_filter :authenticate_admin!
      before_filter :set_general_notification, only: [:destroy, :send_notification]

      authorize_resource class: GeneralNotification.to_s

      def index
        @objects = GeneralNotification.order(created_at: :desc).paginate(page: params[:page])
      end

      def new
        @notification = GeneralNotification.new
      end

      def create
        @notification = GeneralNotification.new(general_notification_params)
        @notification.platform = Platform.first
        @notification.owner = current_admin
        if @notification.save
          redirect_to general_notifications_path, notice: t('views.general_notifications.posts.created')
        else
          @resource = @notification
          render :new
        end
      end

      def destroy
        @notification.destroy
        redirect_to general_notifications_path, notice: t('views.general_notifications.posts.destroyed')
      end

      def send_notification
        @notification.sending!
        GeneralNotificationWorker.perform_async(@notification.id)
        redirect_to general_notifications_path, notice: t('views.general_notifications.posts.sent')
      end

      private

      def general_notification_params
        params.require(:general_notification).permit!
      end


      def set_general_notification
        @notification = GeneralNotification.find(params[:id] || params[:general_notification_id])
      end

    end
  end
end
