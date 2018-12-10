module Api
  module ErrorHelper
    def report_error(e)
      Honeybadger.notify(e)
    end
  end
end
