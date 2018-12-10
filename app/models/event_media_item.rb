class EventMediaItem < ActiveRecord::Base
  belongs_to :event

  include Imagable
  include Videoable
  include Indestructable

  validates :event, presence: true

  scope :active, -> { joins(:event).where(active: true, events: { active: true }) }

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    event&.update_caches
  end

  def type
    media_type.to_sym
  end

  def image_url
    formatted_images[:large_url]
  end

  def sharing_url
    formatted_images[:sharing_url]
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
      original_url: uploaded_url,
      sharing_url: uploaded_url
    }
  end

  def self.placeholder_url
    "https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/event_media_items/images/missing/missing.jpg"
  end

  def videos
    return unless type.eql?(:video)

    if video?
      { original_url: video.url(:original) }
    elsif uploaded_url.present?
      { original_url: uploaded_url }
    end
  end
end
