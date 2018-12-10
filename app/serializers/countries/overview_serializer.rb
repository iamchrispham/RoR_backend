module Countries
  class OverviewSerializer < ApiSerializer
    attributes :name, :region, :currency, :eu_member, :emoji_flag, :international_prefix, :country_code, :alpha2, :alpha3, :geometry

    def name
      return I18n.t('models.countries.united_kingdom.title') if object.alpha2 == 'GB'
      object.name
    end

    def region
      object.region
    end

    def currency
      serialized_resource(object.currency, ::Countries::Currencies::OverviewSerializer)
    end


    def emoji_flag
      country.emoji_flag
    end

    def eu_member
      country.in_eu?
    end

    def international_prefix
      object.international_prefix
    end

    def country_code
      object.country_code
    end

    def alpha2
      object.alpha2
    end

    def alpha3
      object.alpha3
    end

    def geometry
      object.geo["bounds"]
    end

    private
    def country
      ISO3166::Country.find_country_by_alpha2(object.alpha2)
    end
  end
end
