module Videoable
  extend ActiveSupport::Concern

  included do
    has_attached_file :video,
                      url: ':s3_domain_url',
                      path: ':class/:attachment/:hash.:extension',
                      default_url: "https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/:class/:attachment/missing/missing.mp4",
                      hash_secret: ENV['SECRET_KEY_BASE'],
                      styles: {
                        thumb: {
                          format: 'jpg',
                          time: 1,
                          default_url: "https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/:class/:attachment/missing/missing.jpg",
                        }
                      },
                      processors: [:transcoder]

    validates_attachment_content_type :video,
                                      content_type: ['video/mp4'],
                                      message: 'Sorry, right now we only support MP4 video'
    
  end

  def videos
    return nil unless video?

    {
      original_url: video.url(:original)
    }
  end

  def video_images
    return missing_images unless video?

    {
      small_url: video.url(:thumb),
      medium_url: video.url(:thumb),
      large_url: video.url(:thumb),
      original_url: video.url(:thumb),
      sharing_url: video.url(:thumb)
    }
  end

  def missing_thumb
    "https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/#{self.class.to_s.underscore.pluralize}/videos/missing/missing.jpg"
  end

  def missing_images
    {
      small_url: missing_thumb,
      medium_url: missing_thumb,
      large_url: missing_thumb,
      original_url: missing_thumb,
      sharing_url: missing_thumb
    }
  end
end
