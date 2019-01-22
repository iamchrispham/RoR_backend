# frozen_string_literal: true

module SpecialOffers
  class OverviewSerializer < ApiSerializer
    attributes :id,
               :active,
               :title,
               :publish_on,
               :starts_at,
               :ends_at,
               :details,
               :images
  end
end
