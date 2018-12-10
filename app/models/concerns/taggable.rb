module Taggable
  extend ActiveSupport::Concern
  include Twitter::Extractor

  included do
    has_many :tagged_objects, as: :taggable, dependent: :destroy
    has_many :tags, through: :tagged_objects

    before_save :parse_tags
    after_destroy :destroy_tagged_objects
  end

  class_methods do
    def taggable_owner(owner)
      class_eval "def taggable_owner; self.send('#{owner}'); end"
    end

    def taggable_attributes(*attributes)
      attributes = [attributes] unless attributes.is_a?(Array)
      class_eval "def taggable_attributes; #{attributes}; end"
    end
  end

  private

  def destroy_tagged_objects
    TaggedObject.where(taggable: self).destroy_all
  end

  def parse_tags
    unless destroyed?
      if respond_to?(:taggable_owner) && respond_to?(:taggable_attributes)
        send(:taggable_attributes).each do |attribute|
          next unless respond_to?(attribute)
          tagged_attribute = TaggedAttribute.find_or_create_by(attribute_name: attribute.to_s)

          hash_tags = extract_hashtags_with_indices(send(attribute))
          self.tagged_objects = hash_tags.map do |extracted_tag|
            tag = Tag.find_or_create_by(text: extracted_tag[:hashtag])
            tagged_objects.find_or_initialize_by(tag: tag,
                                                 tagged_attribute: tagged_attribute,
                                                 start_index: extracted_tag[:indices].first,
                                                 end_index: extracted_tag[:indices].last,
                                                 owner: taggable_owner)
          end
        end
      else
        raise NotImplementedError, "#{self.class.name} must define taggable_owner and taggable_attributes"
      end
    end
  end
end
