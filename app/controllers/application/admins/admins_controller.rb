module Application
  module Admins
    class AdminsController < WebController
      before_filter :authenticate_admin!
      before_filter :set_admin

      authorize_resource

      def index
        @objects = Admin.order(created_at: :desc).paginate(page: params[:page])
      end

      def edit
        if @admin == current_admin
          redirect_to edit_settings_profile_path
        end
      end

      def new
        @admin = Admin.new
      end

      def create
        @admin = Admin.invite!(admin_params.except(:role), current_admin)
        if @admin.persisted?
          @admin.update_attributes(image: admin_params[:image])
          update_admin_role
          redirect_to admins_path, notice: t('views.admins.created')
        else
          @resource = @admin
          render :new
        end
      end

      def update
        if @admin.update_attributes(admin_params.except(:role))
          update_admin_role
          redirect_to admins_path, notice: t('views.admins.updated')
        else
          @resource = @admin
          render :edit
        end
      end

      def destroy
        return if not @admin.invited?
        @admin.delete
        redirect_to admins_path, notice: t('views.admins.destroyed')
      end

      def deactivate
        @admin.deactivate!
        redirect_to admins_path, notice: t('views.admins.deactivated')
      end

      def activate
        @admin.activate!
        redirect_to admins_path, notice: t('views.admins.activated')
      end

      def resend_invitation
        return if not @admin.invited?
        @admin.invite!
        redirect_to admins_path, notice: t('views.admins.resend_invitation')
      end

      private
      def admin_params
        params.require(:admin).permit!
      end

      def set_admin
        @admin = Admin.find(params[:id]) unless params[:id].blank?
        @admin = Admin.find(params[:admin_id]) unless params[:admin_id].blank?


      end

      def update_admin_role
        return if admin_params[:role].blank?
        role = admin_params[:role]
        @admin.roles.each {|r| @admin.remove_role r.name}
        @admin.add_role role
      end

    end
  end
end
