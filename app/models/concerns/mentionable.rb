module Mentionable
  extend ActiveSupport::Concern
  include Twitter::Extractor

  included do
    has_many :mentioned_users, as: :mentionable, dependent: :destroy
    has_many :mentioned_attributes, through: :mentioned_users
    before_save :parse_mentioned_users
    after_destroy :destroy_mentioned_users
  end

  class_methods do
    def mentionable_owner(owner)
      class_eval "def mentionable_owner; self.send('#{owner}'); end"
    end

    def mentionable_attributes(*attributes)
      attributes = [attributes] unless attributes.is_a?(Array)
      class_eval "def mentionable_attributes; #{attributes}; end"
    end

    def mentionable_notifier_class_name(class_name)
      class_eval "def self.mentionable_notifier_class; #{class_name}; end"
    end
  end

  def mentionable_notifier_class
    if self.class.respond_to?(:mentionable_notifier_class)
      self.class.mentionable_notifier_class
    else
      MentionedUserNotifier
    end
  end

  private



  def destroy_mentioned_users
    MentionedUser.where(mentionable: self).destroy_all
  end

  def parse_mentioned_users
    if respond_to?(:mentionable_owner) && respond_to?(:mentionable_attributes)
      send(:mentionable_attributes).each do |attribute|
        next unless respond_to?(attribute)
        mentioned_attribute = MentionedAttribute.find_or_create_by(attribute_name: attribute.to_s)

        extracted_users = extract_mentioned_screen_names_with_indices(send(attribute))
        extracted_mentioned_users = []
        extracted_users.each do |extracted_user|
          user = User.find_by(username: extracted_user[:screen_name])
          next unless user

          extracted_mentioned_users << mentioned_users.find_or_initialize_by(mentioned_user: user,
                                                                             mentioned_attribute: mentioned_attribute,
                                                                             start_index: extracted_user[:indices].first,
                                                                             end_index: extracted_user[:indices].last,
                                                                             owner: mentionable_owner)
        end
        self.mentioned_users = extracted_mentioned_users
      end
    else
      raise NotImplementedError, "#{self.class.name} must define mentionable_owner and mentionable_attributes"
    end
  end
end
