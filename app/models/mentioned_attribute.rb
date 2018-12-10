class MentionedAttribute < ActiveRecord::Base
  has_many :mentioned_users, dependent: :destroy

  validates :attribute_name, uniqueness: true, presence: true
end
