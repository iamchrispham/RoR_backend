class IdentificationType < ActiveRecord::Base
  include Indestructable

  translates :name

  has_many :identifications

  validates :name, presence: true
end
