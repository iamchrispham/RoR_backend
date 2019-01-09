class Company < ActiveRecord::Base
  include Showoff::Concerns::Imagable
  include Api::CacheHelper
  include Showoff::Helpers::SerializationHelper

  belongs_to :user

  validates :title, presence: true

  after_save :update_caches
  before_destroy :update_caches
  after_destroy :update_caches

  def cache_key(type = :overview)
    key = "company_#{id}_"
    key = "_#{type}_#{key}_" unless type.nil?

    key
  end

  def cache_serializer
    ::Companies::OverviewSerializer
  end

  def cached(cache_user = nil, type: :overview)
    key = "user_#{cache_user&.id}_#{cache_key(type)}"

    cached_company = cached_object key do
      cached_company = cached_object cache_key(type) do
        serialized_resource(self, cache_serializer, user: nil)
      end
    end

    cached_company
  end

  def update_caches
    user&.update_caches
    remove_cached_object(cache_key(nil))

    cached(type: :overview)
  end
end