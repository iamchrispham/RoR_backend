module Api
  module V1
    module Users
      class NotificationSettingsController < ApiController
        before_action :validate_settings_options, only: [:create]

        def update
          notification_settings_options.each do |setting|
            next if setting[:slug].blank?
            notification_setting = current_api_user.notification_setting_user_notification_settings
                                       .joins(:notification_setting)
                                       .where(notification_settings: {slug: setting[:slug]}).first

            notification_setting.update_attributes(enabled: setting[:enabled]) if notification_setting.present? && !setting[:enabled].nil?
          end

          user = current_api_user
          if user.update_attributes(updated_at: Time.now)
            success_response(user: current_api_user.cached(current_api_user, type: :private))
          else
            active_record_error_response(user)
          end
        rescue StandardError => e
          report_error(e)
          error_response(I18n.t('api.responses.internal_error'), Showoff::ResponseCodes::INVALID_ARGUMENT)
        end

        private

        def user_notification_settings_params
          params.require(:user_notification_settings).permit!
        end

        def notification_settings_options
          user_notification_settings_params[:notification_settings]
        end

        def valid_settings_slugs
          NotificationSetting.pluck(:slug)
        end

        def validate_settings_options
          options_slugs = notification_settings_options.collect { |o| o[:slug] }.sort
          if options_slugs.sort != valid_settings_slugs.sort
            error_response(I18n.t('api.responses.user_notification_settings.invalid_options'), Showoff::ResponseCodes::MISSING_ARGUMENT)
          end
        end
      end
    end
  end
end
