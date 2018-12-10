module Api
  module V1
    module Events
      module Timelines
        class TimelineController < TimelinesBaseController

          skip_before_action :set_timeline_item, only: [:index, :create]

          def index
            success_response(
              feed_items: serialized_resource(
                event_timeline_item_service.index(@event, params),
                serializer,
                user: current_api_user
              )
            )
          end

          def create
            timeline_item = event_timeline_item_service.create(@event, timeline_item_params, current_api_user)
            if event_timeline_item_service.errors.nil?
              success_response(
                feed_item: serialized_resource(
                  timeline_item,
                  serializer,
                  user: current_api_user
                )
              )
            else
              error = event_timeline_item_service.errors.first
              error_response(error[:message], error[:type])
            end
          end

          def destroy
            if @timeline_item.deactivate!
              success_response(destroyed: true)
            else
              active_record_error_response(@timeline_item)
            end
          end

          private

          def serializer
            ::Feeds::Items::OverviewSerializer
          end
        end
      end
    end
  end
end
