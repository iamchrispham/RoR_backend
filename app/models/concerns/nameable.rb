module Nameable
  extend ActiveSupport::Concern

  included do
    validates :first_name, :last_name, presence: true
    validates :first_name, :last_name, length: { minimum: 1 }
  end

  # name
  def name
    return '' if (!respond_to? :first_name) || (!respond_to? :last_name)
    return '' if first_name.blank? && last_name.blank?
    first_name + ' ' + last_name
  end
  end
