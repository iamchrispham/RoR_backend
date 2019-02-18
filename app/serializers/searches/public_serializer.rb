module Searches
  class PublicSerializer < ApiSerializer
    attributes :id, :type, :name, :images

    def type
      object.class.name
    end
  end
end
