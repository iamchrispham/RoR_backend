# frozen_string_literal: true

module Application
  module Admins
    class CollegesController < WebController
      before_action :authenticate_admin!

      def index
        @objects = Group.colleges.order(created_at: :desc).paginate(page: params[:page])
      end
    end
  end
end
