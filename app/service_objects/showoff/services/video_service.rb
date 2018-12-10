module Showoff
  module Services
    class VideoService < ApiService

      def import_from_url(url)
        object.send(attribute, URI.parse(url))
        object.save
      end

      private

      def attribute
        if @params[:attribute] && !@attribute
          @attribute = params[:attribute].to_s
          @attribute += '=' unless attribute.ends_with?('=')
        end
        @attribute ||= :video
      end

      def object
        @object ||= @params[:klass].constantize.find_by(id: @params[:id])
      end
    end
  end
end
