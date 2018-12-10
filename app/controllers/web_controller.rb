require 'will_paginate/array'

class WebController < ApplicationController
  include Application::UrlHelper
  include Application::DataSourceHelper
  include Application::GraphDataHelper

  devise_group :admin, contains: %i[admin developer]

  before_filter :check_activation
  before_action :set_last_active, if: proc { current_admin.present? }
  before_action :set_paper_trail_whodunnit

  # cancan helpers
  def current_ability
    @current_ability ||= if current_admin
                           Ability.new(current_admin)
                         else
                           raise CanCan::AccessDenied
                         end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_with_error(root_url, exception.message)
  end

  # not found exception
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  def not_found
    redirect_with_error(dashboard_url, t('views.defaults.object_not_found'))
  end

  def user_for_paper_trail
    current_admin.name if current_admin.present?
  end

  def set_filter_start_and_end
    @start_at ||= Time.now.beginning_of_year
    @end_at ||= Time.now

    @start_at = Time.at(params[:start_at].to_i) if params[:start_at]
    @end_at = Time.at(params[:end_at].to_i) if params[:end_at]

    if params[:filterrific]
      @start_at = Time.at(params[:filterrific][:start_at].to_i) if params[:filterrific][:start_at]
      @end_at = Time.at(params[:filterrific][:end_at].to_i) if params[:filterrific][:end_at]
    end

    params[:filterrific]&.delete(:start_at)
    params[:filterrific]&.delete(:end_at)
  end

  private

  def set_last_active
    Time.zone = 'UTC'
    current_admin.update_attribute(:last_active, Time.zone.now) if current_admin.respond_to?(:last_active)
    session[:last_active] = Time.zone.now
  end

  def check_activation
    if current_admin
      sign_out_and_redirect_with_error(t('views.defaults.sessions.deactivated')) unless current_admin.active
    end
  end
end
