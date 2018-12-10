module Configurations
  class GenericConfigurationSerializer < ApiSerializer
    attributes :identification_types, :countries, :currencies, :urls, :bonuses


    def countries
      serialized_resource(object[:countries], ::Countries::OverviewSerializer)
    end

    def currencies
      serialized_resource(object[:currencies], ::Countries::Currencies::OverviewSerializer)
    end

    def identification_types
      serialized_resource(object[:identification_types], ::Identifications::Types::OverviewSerializer)
    end

    def urls
      object[:urls]
    end

    def bonuses
      object[:bonuses]
    end


  end
end
