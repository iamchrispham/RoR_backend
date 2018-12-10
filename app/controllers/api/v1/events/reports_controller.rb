module Api
  module V1
    module Events
      class ReportsController < EventsBaseController
        def create
          event_report = current_api_user.reported_objects.build(reportable: @event)
          event_report.reason = Report.reasons[report_params[:reason]] if params[:report].present?

          if event_report.save
            success_response(reported: true)
          else
            active_record_error_response(event_report)
          end

        end

        private
        def report_params
          params.require(:report).permit(:reason)
        end
      end
    end
  end
end
