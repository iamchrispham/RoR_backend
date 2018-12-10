module Showoff
  module Services
    class Base
      attr_reader :errors, :params

      def initialize(params = nil)
        @params = params
      end

      def register_error(type, message)
        @errors = [] if @errors.nil?
        @errors << { type: type, message: message }
        nil
      end

      def method_missing(method)
        if params
          return params.send(method) if params.respond_to?(method)
          return params[method] if params.is_a?(Hash) && params.key?(method)
        end

        super
      end
    end
  end
end
