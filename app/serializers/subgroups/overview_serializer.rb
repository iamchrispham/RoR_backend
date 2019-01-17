# frozen_string_literal: true

module Subgroups
  class OverviewSerializer < ApiSerializer
    attributes :id,
               :name,
               :active,
               :location,
               :about,
               :user_id,
               :parent_id,
               :created_at,
               :images,
               :contacts

    def contacts
      serialized_resource(object.contacts, ::Contacts::OverviewSerializer)
    end
  end
end
