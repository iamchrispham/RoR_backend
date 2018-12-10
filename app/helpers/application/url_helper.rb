module Application
  module UrlHelper
    def logout_url
      if current_admin.is_a? Admin
        destroy_admin_session_path
      elsif current_admin.is_a? Developer
        destroy_developer_session_path
      end
    end

    def dashboard_url(options = nil)
      if current_admin.is_a? Admin
        admin_dashboard_path(options)
      elsif current_admin.is_a? Developer
        developer_dashboard_path(options)
      end
    end

    def admin_image_url
      current_admin.image.url(:small) if current_admin.respond_to? :image
    end

    def admin_name
      return current_admin.name
    end

    def android?
      request.user_agent =~ /Android/i
    end

    def ios?
      request.user_agent =~ /iPhone|iPad/i
    end

    def ajax_redirect_to(redirect_uri)
      { js: "window.location.replace('#{redirect_uri}');" }
    end
  end
end
