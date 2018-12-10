class EventContributionType < ActiveRecord::Base
  include Indestructable

  has_many :event_contribution_details
  has_many :events, through: :event_contribution_details

  validates :name, :slug, :cta_title, :cta_description, :change_amount_title, :change_amount_description, presence: true

end
