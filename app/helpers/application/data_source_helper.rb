module Application
  module DataSourceHelper
    include Api::CacheHelper
    def set_admin_dashboard_data
      return if current_admin.blank?

      @user_period = params[:user_period]
      @event_period = params[:event_period]
    end

    def sign_out_and_redirect_with_error(error)
      sign_out_all_scopes
      redirect_with_error(login_url, error)
    end

    def redirect_with_error(url, error = nil)
      if error
        flash[:error] = error
        flash.keep
      end
      redirect_to url
    end

  end
end
