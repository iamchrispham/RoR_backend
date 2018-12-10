module Addresses
  class OverviewSerializer < ApiSerializer
    attributes :id, :line1, :line2, :city, :state, :postal_code, :country, :active, :created_at, :updated_at

    def active
      return false if !object.respond_to? :active
      object.active
    end

    def country
      serialized_resource(object.country, ::Countries::OverviewSerializer)
    end

  end
end
