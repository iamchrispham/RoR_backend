module Currencyable
  extend ActiveSupport::Concern

  included do
    def country_object
      @county ||= ISO3166::Country.find_country_by_alpha2(country_code)
    end

    def currency
      return MoneyRails.default_currency if country_object.blank?
      country_object.currency
    end

    def currency_symbol
      currency.symbol
    end
  end
end
