class EventTimelineItemMediaItem < ActiveRecord::Base
  include Indestructable

  include Showoff::Concerns::Imagable
  include Videoable

  belongs_to :event_timeline_item
  has_one :event, through: :event_timeline_item

  validates :event_timeline_item, presence: true

  scope :active, -> { joins(:event).where(events: { active: true }).where(active: true) }

  def type
    media_type.to_sym
  end

  def formatted_images
    return video_images if type == :video
    return images if image?
    uploaded_images
  end

  def uploaded_images
    {
      small_url: uploaded_url,
      medium_url: uploaded_url,
      large_url: uploaded_url,
      original_url: uploaded_url
    }
  end

  def videos
    if type.eql?(:video)
      if video?
        { original_url: video.url(:original) }
      elsif uploaded_url.present?
        { original_url: uploaded_url }
      end
    end
  end
end
