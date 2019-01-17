# frozen_string_literal: true

class Post < ActiveRecord::Base
  include Showoff::Concerns::Imagable
  include Indestructable

  belongs_to :postable, polymorphic: true

  validates :title, presence: true, uniqueness: true
  validates :details, presence: true
end
