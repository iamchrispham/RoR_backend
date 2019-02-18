# frozen_string_literal: true

class ApiController < ActionController::Base
  protect_from_forgery with: :null_session

  include Showoff::Helpers::SerializationHelper
  include Showoff::Helpers::CurrentAPIUserHelper
  include Api::ResponseHelper
  include Api::DoorkeeperHelper
  include Api::EventHelper
  include Api::CacheHelper
  include UserSessionHelper
  include HttpAcceptLanguage::AutoLocale
  include Api::ErrorHelper
  include Api::UserHelper
  include Api::CommentHelper

  # before_action :doorkeeper_authorize!
  before_action :current_api_user, :set_pagination, :ensure_api_version_is_correct
  before_action :store_request_in_thread

  respond_to :json

  rescue_from ActionController::ParameterMissing do |exception|
    missing_argument_response(exception)
  end

  def set_pagination
    params[:offset] = Api::ActiveRecord::DEFAULT_OFFSET unless params[:offset]
    params[:limit] = Api::ActiveRecord::DEFAULT_LIMIT unless params[:limit]
  end

  def ensure_api_version_is_correct
    @api_version = request.headers['HTTP_API_VERSION'].to_f
  end

  def user_service
    @user_service ||= UserService.new
  end

  def offset
    params[:offset]
  end

  def limit
    params[:limit]
  end
end
