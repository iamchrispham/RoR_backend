class Address < ActiveRecord::Base
  include Indestructable

  belongs_to :user

  validates :country_code, :line1, :city, presence: true

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
  end

  def country
    @country ||= ISO3166::Country.find_country_by_alpha2(country_code)
  end

  scope :default, -> { where(default: true, active: true) }

  def address_string
    [line1, line2, city, state, postal_code, country.name].reject(&:blank?).join(', ')
  end
end
