module Periodable
  extend ActiveSupport::Concern

  included do
    scope :last_period, ->(time) {
      where(arel_table[:created_at].gteq(time.beginning_of_day))
        .order(created_at: :desc)
    }
  end
end
