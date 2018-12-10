module Application
  module Identifications
    class IdentificationsController < WebController
      authorize_resource class: 'Identification'

      before_filter :authenticate_admin!, only: [:show]
      before_filter :set_identification, except: [:index]

      def index
        (@filterrific = initialize_filterrific(
            Identification,
            params[:filterrific],
            select_options: {
                sorted_by: Identification.options_for_sorted_by,
                with_status: Identification.options_for_status,
            }
        )) || return

        @scope = if params[:filterrific]
                   params[:filterrific][:with_status]
                 else
                   :all
                 end
        @scope = @scope.to_sym

        @objects = @filterrific.find.paginate(page: params[:page])

        @objects.map {|o| o.record_view(current_admin)}
      end

      def show
        @user = @identification.user
      end

      def verify
        @identification.verify(current_admin)
        redirect_to identification_path(@identification), notice: t('views.identifications.verified')
      end

      def reject
        @identification.reject(current_admin)
        redirect_to identification_path(@identification), notice: t('views.identifications.rejected')
      end

      def reset
        @identification.reset!
        redirect_to identification_path(@identification), notice: t('views.identifications.reset')
      end

      private

      def drivers_license_params
        params.require(:drivers_license).permit!
      end

      def set_identification
        @identification = Identification.find(params[:id]) unless params[:id].blank?
        @identification = Identification.find(params[:identification_id]) unless params[:identification_id].blank?

        @identification.record_view(current_admin) if @identification.present?
      end

    end
  end
end
