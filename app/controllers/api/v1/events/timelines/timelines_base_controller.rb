module Api
  module V1
    module Events
      module Timelines
        class TimelinesBaseController < EventsBaseController

          before_action :set_timeline_item

          private
          def set_timeline_item
            @timeline_item = EventTimelineItem.active.find_by(id: params[:timeline_id] || params[:id])

            if @timeline_item.blank?
              error_response(I18n.t('api.responses.events.timelines.item.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
            end
          end

          def timeline_item_params
            params.require(:timeline_item).permit!
          end

          def event_timeline_item_service
            @event_timeline_item_service ||= EventTimelineItemService.new
          end

        end
      end
    end
  end
end
