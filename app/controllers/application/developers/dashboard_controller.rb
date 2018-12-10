module Application
  module Developers
    class DashboardController < WebController
      before_filter :authenticate_developer!

      def index
      end

    end
  end
end
