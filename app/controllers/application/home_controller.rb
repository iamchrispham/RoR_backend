module Application
  class HomeController < WebController
    layout false

    def index
      if current_admin
        redirect_to dashboard_url
      else
        redirect_to login_url
      end
    end

    def login
      flash.keep
      render action: 'login', layout: 'no_session'
    end

    def register
      flash.keep
      render action: 'register', layout: 'no_session'
    end

  end
end
