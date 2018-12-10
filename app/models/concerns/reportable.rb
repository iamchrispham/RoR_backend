module Reportable
  extend ActiveSupport::Concern

  included do
    has_many :reports, as: :reportable, dependent: :destroy
    has_many :reporters, through: :reports, source: :reporter, source_type: 'User'

    scope :pending_reports, -> {
      joins(:reports)
        .where(reports: { considered: false })
        .group(:id)
        .uniq
    }
  end

  class_methods do
    def after_report(action)
      class_eval "def after_report_action; self.send('#{action}'); end"
    end
  end

  def reported_action
    after_report_action if respond_to?(:after_report_action)
  end
end
