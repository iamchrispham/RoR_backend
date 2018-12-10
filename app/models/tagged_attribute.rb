class TaggedAttribute < ActiveRecord::Base
  has_many :tagged_objects, dependent: :destroy

  validates :attribute_name, uniqueness: true, presence: true
end
