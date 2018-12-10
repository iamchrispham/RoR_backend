class ConfigurationService < ApiService
  include Showoff::Helpers::SerializationHelper
  include Api::CacheHelper
  include Api::RequestHelper
  include UserSessionHelper
  include Api::Referrals::ReferralHelper
  include Rails.application.routes.url_helpers

  def generic_settings
    cached_object(generic_settings_cache_key, :settings_object)
  end

  private

  def countries
    countries = []

    # NOTE: Stripe Support Countries
    country_list = %w[AU
                      AT
                      BE
                      CA
                      DK
                      FI
                      FR
                      DE
                      HK
                      IE
                      JP
                      LU
                      NL
                      NZ
                      NO
                      SG
                      ES
                      SE
                      CH
                      GB
                      US
                      IT
                      PT]

    country_list.each do |c|
      countries << ISO3166::Country.find_country_by_alpha2(c)
    end
    countries
  end

  def currencies
    # NOTE: Stripe Support Currencies
    currencies = []
    currency_list = %w[USD
                       AED
                       AFN
                       ALL
                       AMD
                       ANG
                       AOA
                       ARS
                       AUD
                       AWG
                       AZN
                       BAM
                       BBD
                       BDT
                       BGN
                       BIF
                       BMD
                       BND
                       BOB
                       BRL
                       BSD
                       BWP
                       BZD
                       CAD
                       CDF
                       CHF
                       CLP
                       CNY
                       COP
                       CRC
                       CVE
                       CZK
                       DJF
                       DKK
                       DOP
                       DZD
                       EGP
                       ETB
                       EUR
                       FJD
                       FKP
                       GBP
                       GEL
                       GIP
                       GMD
                       GNF
                       GTQ
                       GYD
                       HKD
                       HNL
                       HRK
                       HTG
                       HUF
                       IDR
                       ILS
                       INR
                       ISK
                       JMD
                       JPY
                       KES
                       KGS
                       KHR
                       KMF
                       KRW
                       KYD
                       KZT
                       LAK
                       LBP
                       LKR
                       LRD
                       LSL
                       MAD
                       MDL
                       MGA
                       MKD
                       MMK
                       MNT
                       MOP
                       MRO
                       MUR
                       MVR
                       MWK
                       MXN
                       MYR
                       MZN
                       NAD
                       NGN
                       NIO
                       NOK
                       NPR
                       NZD
                       PAB
                       PEN
                       PGK
                       PHP
                       PKR
                       PLN
                       PYG
                       QAR
                       RON
                       RSD
                       RUB
                       RWF
                       SAR
                       SBD
                       SCR
                       SEK
                       SGD
                       SHP
                       SLL
                       SOS
                       SRD
                       STD
                       SVC
                       SZL
                       THB
                       TJS
                       TOP
                       TRY
                       TTD
                       TWD
                       TZS
                       UAH
                       UGX
                       UYU
                       UZS
                       VND
                       VUV
                       WST
                       XAF
                       XCD
                       XOF
                       XPF
                       YER
                       ZAR
                       ZMW]
    currency_list.each do |c|
      currencies << Money::Currency.find(c)
    end
    currencies
  end

  def identification_types
    IdentificationType.active
  end

  def bonus_details
    # NOTE in future Phase use 'user.default_currency' for the currency here.
    {
      referral: {
        title: I18n.t('api.responses.referrals.invite.title', currency: MoneyRails.default_currency.symbol, value: referral_user_invite_amount / 100),
        terms_url: root_url(host: current_request.env['HTTP_HOST']),
        social: {
          title: I18n.t('api.responses.referrals.invite.social.title'),
          description: I18n.t('api.responses.referrals.invite.social.description', currency: MoneyRails.default_currency.symbol, value: referral_user_registration_amount / 100),
          image: referral_user_invite_social_image_url
        }
      }
    }
  end

  def generic_settings_cache_key
    'go_generic_settings'
  end

  def urls
    {
      terms: ENV['TERMS_URL'],
      privacy_policy: ENV['PRIVACY_POLICY_URL'],
      support: ENV['SUPPORT_URL']

    }
  end

  def settings_object
    settings = {
      bonuses: bonus_details,
      countries: countries,
      currencies: currencies,
      identification_types: identification_types,
      urls: urls
    }
    serialized_resource(settings, ::Configurations::GenericConfigurationSerializer).as_json
  end
end
