module Application
  module Admins
    class DashboardController < WebController
      before_filter :authenticate_admin!

      def index
        set_admin_dashboard_data
      end

    end
  end
end
