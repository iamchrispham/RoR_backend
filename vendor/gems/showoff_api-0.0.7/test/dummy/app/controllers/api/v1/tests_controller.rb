module Api
  module V1
    class TestsController < ActionController::Base
      include Api::V1::TestsDoc
      def index
      end
    end
  end
end
