class UserAgeRange < ActiveRecord::Base
  include Indestructable

  translates :name
  validates :name, :start_age, :end_age, presence: true

  has_many :users

end
