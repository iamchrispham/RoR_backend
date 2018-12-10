module Payments
  module Source
    class OverviewSerializer < ApiSerializer
      attributes :id, :brand, :country, :cvc_check, :exp_month, :exp_year, :last_four, :default
    end
  end
end