module Tags
  class OverviewSerializer < ApiSerializer
    attributes :tag_id, :tag, :start_index, :end_index

    def tag_id
      object.tag.id
    end

    def tag
      object.tag.text
    end
  end
end
