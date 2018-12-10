module Application
  module Users
    class UserLoginsController < WebController
      before_filter :authenticate_admin!
      before_filter :set_user, :set_user_login

      authorize_resource

      def destroy
        if @login.revoke!
          redirect_to redirect_path, notice: t('views.users.show.content.user_logins.revoked')
        else
          redirect_with_error(redirect_path, t('views.users.show.content.user_logins.revoked_error'))
        end
      end

      private
      def set_user
        @user = current_admin.users.find(params[:user_id]) unless params[:user_id].blank?
      end

      def set_user_login
        @login = @user.user_logins.find(params[:id]) unless params[:id].blank?
      end

      def redirect_path
        request.referrer
      end
    end
  end
end
