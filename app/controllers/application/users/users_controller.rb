module Application
  module Users
    class UsersController < WebController
      include Application::UserHelper
      before_filter :authenticate_admin!
      before_filter :set_user, :set_user_show_scope, except: [:index]

      authorize_resource

      def index
        (@filterrific = initialize_filterrific(
            User,
            params[:filterrific],
            select_options: {
                sorted_by: User.options_for_sorted_by,
                by_gender: User.options_for_gender,
                by_type: User.options_for_type,
                by_age_range: User.options_for_age_range
            }
        )) || return
        @objects = @filterrific.find.where(id: current_admin.users.pluck(:id)).paginate(page: params[:page])
      end

      def show
        @hosting_events = @user.hosting_events.paginate(page: params[:hosting_event_page])
        @attending_events = @user.attending_events.paginate(page: params[:attending_event_page])
        @maybe_attending_events = @user.maybe_attending_events.paginate(page: params[:maybe_attending_event_page])
        @user_logins = @user.user_logins.order(updated_at: :desc).paginate(page: params[:login_page])
        @reports = @user.reported_by.order(updated_at: :desc).paginate(page: params[:report_page])
      end

      def deactivate
        if @user.can_deactivate?
          if @user.revoke_all_sessions! && @user.deactivate_all_events!
            @user.deactivate!
            redirect_to user_path(@user), notice: t('views.users.deactivated')
          else
            redirect_with_error(user_path(@user), t('views.users.error_deactivate'))
          end
        else
          redirect_with_error(user_path(@user), t('views.users.cannot_deactivate'))
        end
      end

      def activate
        if @user.update_attributes(suspended: false, suspended_at: nil, active: true)
          redirect_to user_path(@user), notice: t('views.users.activated')
        else
          redirect_with_error(user_path(@user), t('views.users.error_activate'))
        end
      end

      def unsuspend
        if @user.update_attributes(suspended: false, suspended_at: nil)
          redirect_to user_path(@user), notice: t('views.users.unsuspend')
        else
          redirect_with_error(user_path(@user), t('views.users.error_unsuspend'))
        end
      end

      def suspend
        if @user.revoke_all_sessions!
          @user.update_attributes(suspended: true, suspended_at: Time.now)
          redirect_to user_path(@user), notice: t('views.users.suspended')
        else
          redirect_with_error(user_path(@user), t('views.users.error_suspended'))
        end
      end

      private

      def set_user
        @user = current_admin.users.find(params[:user_id] || params[:id])
      end

      def set_user_show_scope
        @scope = params[:scope] || :details
      end
    end
  end
end
