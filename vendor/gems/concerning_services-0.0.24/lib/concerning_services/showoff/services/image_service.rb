module Showoff
  module Services
    class ImageService < Base
      include Showoff::Concerns::ImageDecodable

      def import_from_url(url)
        object.send(attribute, URI.parse(url))
        object.save
      end

      def import_from_data(data)
        object.send(attribute, decode_base_64_image(data))
        object.save
      end

      def import_from_gravatar(email)
        gravatar_id = Digest::MD5.hexdigest(email)
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}.png?d=mm&s=800"
        import_from_url(gravatar_url)
      end

      private

      def attribute
        if @params[:attribute] && !@attribute
          @attribute = params[:attribute].to_s
          @attribute += '=' unless attribute.ends_with?('=')
        end
        @attribute ||= :image
      end

      def object
        @object ||= @params[:klass].constantize.find_by(id: @params[:id])
      end
    end
  end
end
