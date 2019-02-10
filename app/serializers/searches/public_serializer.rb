module Searches
  class PublicSerializer < ApiSerializer
    attributes :id, :type, :name, :icon_url

    def type
      object.class.name
    end

    def icon_url
      nil
    end
  end
end
