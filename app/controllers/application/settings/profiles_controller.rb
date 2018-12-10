module Application
  module Settings
    class ProfilesController < WebController
      before_filter :authenticate_admin!
      before_filter :set_resource

      def edit
        authorize! :read, @resource
      end

      def update
        authorize! :update, @resource
        if @resource.update_attributes(object_settings_params)
          flash[:notice] = t 'views.profile.update.success'
          redirect_to edit_settings_profile_path
        else
          render :show
        end
      end

      def object_settings_params
        params.require(:resource).permit(:first_name, :last_name, :image, :email)
      end

      def set_resource
        @resource = current_admin
      end
    end
  end
end
