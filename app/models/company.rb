class Company < ActiveRecord::Base
  include Showoff::Concerns::Imagable
  include Api::CacheHelper
  include Showoff::Helpers::SerializationHelper
  include Currencyable

  alias_attribute :name, :title

  belongs_to :user
  has_many :events, as: :event_ownerable

  validates :title, presence: true

  scope :active, -> {where(active: true, suspended: false)}
  scope :inactive, -> {where(arel_table[:active].eq(false).or(arel_table[:suspended].eq(true)))}
  scope :search_by_title, ->(text) { where("title ILIKE ?", "%#{text}%") }

  after_save :update_caches
  before_destroy :update_caches
  after_destroy :update_caches

  def cache_key(type = :feed)
    key = "company_#{id}_"
    key = "_#{type}_#{key}_" unless type.nil?

    key
  end

  def cache_serializer(type = :feed)
    case type
    when :feed
      ::Companies::OverviewSerializer
    when :public
      ::Companies::Feed::OverviewSerializer
    else
      ::Companies::OverviewSerializer
    end
  end

  def cached(cache_user = nil, type: :feed)
    key = "user_#{cache_user&.id}_#{cache_key(type)}"

    cached_company = cached_object key do
      cached_company = cached_object cache_key(type) do
        serialized_resource(self, cache_serializer(type), user: nil)
      end
    end

    cached_company
  end

  def update_caches
    user&.update_caches
    remove_cached_object(cache_key(nil))

    %i[feed public].each do |type|
      cached(type: type)
    end
  end
end