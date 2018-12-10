class EventTimelineItemService < ApiService
  include Api::CacheHelper

  def index(event, params)
    timelines_items = event.event_timeline_items.active.includes([:event_timeline_item_media_items]).active.order(created_at: :desc).limit(params[:limit]).offset(params[:offset])

    proxy_timelines_items = []
    timelines_items.each do |timeline_item|
      proxy_timelines_items << ::Feed::FeedItemProxy.new(timeline_item)
    end
    proxy_timelines_items
  end

  def create(event, params, current_api_user)
    timeline_item = timeline_item_for_params(event, params, current_api_user)

    media_items = params[:media_items]
    minimum_media_count = 1
    if media_items.nil? || media_items.length < minimum_media_count
      register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, I18n.t('api.responses.events.minimum_number_of_media_items', count: minimum_media_count))
    elsif timeline_item.present? && timeline_item.valid?
      timeline_item.save!

      # save media items
      save_media_items(timeline_item, media_items)

      # return proxy item
      ::Feed::FeedItemProxy.new(timeline_item)
    else
      register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, timeline_item.errors.full_messages.first)
    end
  rescue StandardError => e
    report_error(e)
    timeline_item.delete!
    register_error(Showoff::ResponseCodes::INTERNAL_ERROR, e.message)
  end

  private

  def valid_sources
    %w(video image text)
  end

  def timeline_item_for_params(event, params, current_api_user)
    # set up event_timeline_item object
    base_params = params.except(:media_items)
    timeline_item = event.event_timeline_items.new(base_params)
    timeline_item.user = current_api_user
    timeline_item
  end

  def save_media_items(timeline_item, media_items)
    media_items.each do |source|
      source = source.with_indifferent_access

      type = source[:type]
      next unless valid_sources.include? type
      url = source[:url]
      next unless type.eql?('text') || url.present?

      # process media item
      media_item = EventTimelineItemMediaItem.new(event_timeline_item: timeline_item)
      media_item.media_type = type
      media_item.uploaded_url = url
      media_item.text = source[:content]

      if media_item.valid?
        media_item.save!

        case type
        when 'video'
          Showoff::Workers::ImageWorker.perform_async(media_item.class.to_s,  media_item.id, {url: url}, :video)
        when 'image'
          Showoff::Workers::ImageWorker.perform_async(media_item.class.to_s,  media_item.id, url: url )
        end
      else
        register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, media_item.errors.full_messages.first)
        break
      end
    end
  end
end
