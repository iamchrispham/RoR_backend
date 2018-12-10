module Showoff
  module Concerns
    module ImageDecodable
      extend ActiveSupport::Concern

      def decode_base_64_image(image_data)
        image = Paperclip.io_adapters.for(image_data)

        image_data =~ /^data:image\/(.+);base64.*/

        detected_type = Regexp.last_match(1).nil? ? 'jpg' : Regexp.last_match(1)

        image.original_filename = "#{SecureRandom.hex(32)}.#{detected_type}"

        image
      end
    end
  end
end
