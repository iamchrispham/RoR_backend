module Application
  module Reports
    class UsersController < WebController
      before_filter :set_user, except: [:index]

      def index
        @objects = User.pending_reports.order(suspended_at: :desc, inactive_at: :desc).paginate(page: params[:page]).uniq
      end

      private

      def reports_considered!
        @user.reports.update_all(considered: true)
      end

      def set_user
        @user = User.find_by(id: params[:user_id])
      end
    end
  end
end
