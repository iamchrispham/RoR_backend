module Identifications
  class OverviewSerializer < ApiSerializer
    attributes :id, :identification_type, :created_at

    def identification_type
      serialized_resource(object.identification_type, ::Identifications::Types::OverviewSerializer)
    end
  end
end
