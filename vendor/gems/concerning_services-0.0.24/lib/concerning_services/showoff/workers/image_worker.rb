module Showoff
  module Workers
    class ImageWorker
      include ::Sidekiq::Worker

      sidekiq_options queue: :default, retry: 1

      def perform(klass, id, sources, attribute = :image)
        image_service = Showoff::Services::ImageService.new(klass: klass, id: id, attribute: attribute)

        if sources['url']
          image_service.import_from_url(sources['url'])
        elsif sources['data']
          image_service.import_from_data(sources['data'])
        elsif sources['email']
          image_service.import_from_gravatar(sources['email'])
        end
      rescue StandardError => e
        Rails.logger.error(e.message)
      end
    end
  end
end
