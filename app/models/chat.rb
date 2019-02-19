class Chat < ActiveRecord::Base
  belongs_to :chatable, polymorphic: true
end
