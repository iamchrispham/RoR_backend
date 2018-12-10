module Api
  module V1
    module Events
      module Timelines
        module Comments
          class ReportsController < CommentsBaseController
            def create
              report = current_api_user.reported_objects.build(reportable: @comment)
              report.reason = Report.reasons[report_params[:reason]] if params[:report].present?

              if report.save
                success_response(reported: true)
              else
                active_record_error_response(report)
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
  end
end
