# frozen_string_literal: true

module Posts
  class OverviewSerializer < ApiSerializer
    attributes :id,
               :postable_id,
               :postable_type,
               :title,
               :details,
               :active,
               :created_at,
               :images
  end
end
