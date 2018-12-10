module Api
  module V1
    module Events
      class SharesController < EventsBaseController

        def create
          share_params[:users].delete(current_api_user.id)

          share = @event.event_shares.new(user: current_api_user, user_ids: share_params[:users])
          if share.valid?
            share.save!
            success_response(share: serialized_resource(share, ::Events::Shares::OverviewSerializer, user: current_api_user))
          else
            active_record_error_response(share)
          end
        end

        private

        def share_params
          params.require(:share).permit!
        end
      end
    end
  end
end
