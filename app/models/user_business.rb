class UserBusiness < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
  end

  def country
    @country ||= ISO3166::Country.find_country_by_alpha2(country_code)
  end
end
