class Tag < ActiveRecord::Base
  belongs_to :taggable, polymorphic: true
  belongs_to :owner, polymorphic: true

  has_many :tagged_objects, dependent: :destroy
  has_many :user_tags, dependent: :destroy
  has_many :users, through: :user_tags

  validates :text, presence: true, uniqueness: true

  scope :matching, -> (text) { where('text ILIKE ?', "%#{text}%") }

  scope :trending, -> {
    joins(:tagged_objects)
      .where(TaggedObject.arel_table[:created_at].gteq((Time.now - 24.hours)))
      .where(tagged_objects: { taggable_type: 'Event' })
      .group(:id)
      .order('COUNT(tags.id) DESC')
  }

  scope :popular, -> {
    group(:id).order('COUNT(tags.id) DESC')
  }

  scope :promoted, -> {
    joins(:promoted_tags)
  }

  scope :unpromoted, -> {
    where.not(id: promoted)
  }

  def self.sanitize_tag(tag)
    return nil unless tag
    tag = tag[1..-1] if tag.starts_with?('#')
    tag
  end

  def self.options_for_select
    all.map do |tag|
      [tag.text, tag.text]
    end
  end
end
