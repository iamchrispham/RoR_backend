class TaggedObject < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
  belongs_to :owner, polymorphic: true

  belongs_to :tagged_attribute

  validates :tag, uniqueness: { scope: [:owner_id, :owner_type, :start_index, :end_index, :taggable_id, :taggable_type, :tagged_attribute_id] }
  validates :tag, :tagged_attribute, :owner_id, :owner_type, :start_index, :end_index, :taggable_id, :taggable_type, presence: true
end
