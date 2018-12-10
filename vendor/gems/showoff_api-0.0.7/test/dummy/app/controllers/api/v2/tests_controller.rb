module Api
  module V2
    class TestsController < ActionController::Base
      include Api::V2::TestsDoc
      def index
      end
    end
  end
end
