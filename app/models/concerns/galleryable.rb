module Galleryable
  extend ActiveSupport::Concern

  included do
    include Showoff::Helpers::SerializationHelper

    has_many :gallery_images, as: :owner, dependent: :destroy
  end

  def gallery
    serialized_resource(gallery_images.order(created_at: :asc), GalleryImageSerializer).as_json
  end

  def cover_image
    gallery_images.order(updated_at: :desc).first
  end
end
