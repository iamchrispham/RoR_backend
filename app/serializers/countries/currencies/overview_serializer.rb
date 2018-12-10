module Countries
  module Currencies
    class OverviewSerializer < ApiSerializer
      attributes :id, :name, :symbol, :iso_code, :iso_numeric

      def id
        object.id
      end

      def name
        object.name
      end

      def symbol
        object.symbol
      end

      def iso_code
        object.iso_code
      end

      def iso_numeric
        object.iso_numeric
      end
    end
  end
end
