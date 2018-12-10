class GalleryWorker
  include ::Sidekiq::Worker
  include Api::ErrorHelper

  sidekiq_options queue: :default, retry: 1

  def perform(klass, id, sources, attribute = :gallery_images)
    gallery_service = GalleryService.new(klass: klass, id: id, attribute: attribute)

    sources.each do |source|
      if source['url']
        gallery_service.import_from_url(source['url'])
      elsif source['data']
        gallery_service.import_from_data(source['data'])
      elsif source['email']
        gallery_service.import_from_gravatar(source['email'])
      end
    end
  rescue StandardError => e
    report_error(e)
    Rails.logger.error(e.message)
  end
end
