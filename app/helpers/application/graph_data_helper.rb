module Application
  module GraphDataHelper


    def reporting_users_graph_data(period)
      group_column = 'users.created_at'
      time_zone = Time.zone

      if period == graph_period_week
        User.group_by_day(group_column, time_zone: time_zone, last: period).count
      elsif period == graph_period_month
        User.group_by_day(group_column, time_zone: time_zone, last: period).count
      elsif period == graph_period_year
        User.group_by_month(group_column, time_zone: time_zone, last: period).count
      end
    end

    def reporting_events_graph_data(period)
      group_column = 'events.created_at'
      time_zone = Time.zone

      if period == graph_period_week
        Event.group_by_day(group_column, time_zone: time_zone, last: period).count
      elsif period == graph_period_month
        Event.group_by_day(group_column, time_zone: time_zone, last: period).count
      elsif period == graph_period_year
        Event.group_by_month(group_column, time_zone: time_zone, last: period).count
      end
    end

    def graph_options
      { colors: ['#21d0bf'] }
    end

    def graph_period_week
      7
    end

    def graph_period_month
      30
    end

    def graph_period_year
      12
    end

    def dashboard_time_period
      graph_period_week
    end
  end
end
