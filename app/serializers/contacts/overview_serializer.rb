# frozen_string_literal: true

module Contacts
  class OverviewSerializer < ApiSerializer
    attributes :id,
               :contactable_id,
               :contactable_type,
               :category,
               :active,
               :details,
               :images
  end
end
