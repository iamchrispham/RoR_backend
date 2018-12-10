module UserBusinessDetails
  class OverviewSerializer < ApiSerializer
    attributes :id, :name, :tax_id, :address

    def address
      serialized_resource(object, ::Addresses::OverviewSerializer)
    end
  end
end
