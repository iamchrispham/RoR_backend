class GalleryImage < ActiveRecord::Base
  include Showoff::Concerns::Imagable
  
  belongs_to :owner, polymorphic: true

  validates :owner_id, :owner_type, presence: true
  validates :image, presence: true

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    owner.update_caches if owner&.respond_to?(:update_caches)
  end
end
