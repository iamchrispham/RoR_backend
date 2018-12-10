module CoverImageable
  extend ActiveSupport::Concern

  included do
    has_attached_file :cover_image,
                      styles: { small: '512x512>', medium: '1024x1024>', large: '2048x2048>' },
                      default_url: "https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/:class/:attachment/missing/missing.jpg",
                      url: ':s3_domain_url',
                      path: ':class/:attachment/:id_partition/:style/:basename.:extension'

    validates_attachment_content_type :cover_image, content_type: /\Aimage\/.*\Z/
  end

  def cover_images
    {
        small_url: cover_image.url(:small),
        medium_url: cover_image.url(:medium),
        large_url: cover_image.url(:large),
        original_url: cover_image.url
    }
  end

end
