module Api
  module V1
    module Users
      class ReportsController < ApiController

        before_action :set_user

        def create
          user_report = current_api_user.reported_objects.build(reportable: @user)
          user_report.reason = Report.reasons[report_params[:reason]] if params[:report].present?

          if user_report.save
            success_response(reported: true)
          else
            active_record_error_response(user_report)
          end
        end

        private
        def set_user
          @user = User.find_by(id: params[:user_id])
          if @user.blank?
            error_response((t 'api.responses.users.not_found'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          end
        end

        def report_params
          params.require(:report).permit(:reason)
        end
      end
    end
  end
end
