module Showoff
  module Concerns
    module Imagable
      extend ActiveSupport::Concern

      included do
        after_initialize :check_for_environmental_variables

        has_attached_file :image,
                          styles: {
                            small: {
                              geometry: '512x512>',
                              convert_options: '-auto-orient'
                            },
                            medium: {
                              geometry: '1024x1024>',
                              convert_options: '-auto-orient'
                            },
                            large: {
                              geometry: '2048x2048>',
                              convert_options: '-auto-orient'
                            },
                            original: {
                              convert_options: '-auto-orient'
                            }
                          },
                          s3_permissions: lambda { |attachment, style|
                            object = attachment.instance

                            if object.respond_to?(:private_images?) && object.private_images?
                              :private
                            else
                              :'public-read'
                            end
                          },
                          hash_secret: Rails.application.secrets.secret_key_base,
                          s3_server_side_encryption: 'AES256',
                          default_url: "https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/:class/:attachment/missing/missing.jpg",
                          url: ':s3_domain_url',
                          path: lambda { |attachment|
                            object = attachment.instance
                            filetype = object.respond_to?(:hash_images?) && object.hash_images? ? 'hash' : 'basename'

                            ":class/:attachment/:id_partition/:style/:#{filetype}.:extension"
                          }

        validates_attachment_content_type :image, content_type: %r{\Aimage/.*\Z}
      end

      class_methods do
        def private_images
          define_method :private_images? do
            true
          end
        end

        def hash_images
          define_method :hash_images? do
            true
          end
        end
      end

      def images
        {
          small_url: image.url(:small),
          medium_url: image.url(:medium),
          large_url: image.url(:large),
          original_url: image.url
        }
      end

      def private_images(expiration = ENV.fetch('PAPERCLIP_EXPIRATION_TIME', 60))
        {
          small_url: image.expiring_url(expiration, :small),
          medium_url: image.expiring_url(expiration, :medium),
          large_url: image.expiring_url(expiration, :large),
          original_url: image.expiring_url(expiration),
        }
      end

      def standard_image_url(style = :original)
        "#{url_prefix(style)}#{interpolator.basename(image, style)}#{url_suffix(style)}"
      end

      def hashed_image_url(style = :original)
        "#{url_prefix(style)}#{interpolator.hash(image, style)}#{url_suffix(style)}"
      end

      def reprocess_image_from_old_url
        url = hashed_image_url
        if respond_to?(:hash_images?) && hash_images?
          # previous image was standard
          url = standard_image_url
        end

        self.image = URI.parse(url)
        save
      end

      private

      def s3_url
        @s3_url ||= "https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com"
      end

      def interpolator
        @interpolator ||= image.interpolator
      end

      def url_prefix(style = :original)
        "#{s3_url}/#{self.class.name.underscore.pluralize}/#{interpolator.attachment(image, style)}/#{interpolator.id_partition(image, style)}/#{style}/"
      end

      def url_suffix(style = :original)
        interpolator.dotextension(image, style)
      end

      def check_for_environmental_variables
        %w[AWS_BUCKET AWS_REGION AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY].each do |env_variable|
          raise ArgumentError, "ENV[#{env_variable}] must be set to use Showoff::Concerns::Imagable" unless ENV[env_variable].present?
        end
      end
    end
  end
end
