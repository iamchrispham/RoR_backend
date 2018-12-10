module Tags
  class TagSerializer < ApiSerializer
    attributes :id, :text, :count

    def count
      object.tagged_objects.where(taggable_type: 'Event').count
    end
  end
end
