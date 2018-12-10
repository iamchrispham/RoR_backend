class MentionedUser < ActiveRecord::Base
  belongs_to :mentioned_user, class_name: 'User'

  belongs_to :mentionable, polymorphic: true
  belongs_to :owner, polymorphic: true

  belongs_to :mentioned_attribute

  validates :owner_id, uniqueness: { scope: [:owner_type, :start_index, :end_index, :mentionable_id, :mentionable_type, :mentioned_attribute_id] }
  validates :mentioned_attribute, :owner_id, :owner_type, :start_index, :end_index, :mentionable_id, :mentionable_type, presence: true

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    mentioned_user&.update_caches
  end

  private

  def create_notifier
    if mentionable.respond_to?(:mentionable_notifier_class)
      notifier_class = mentionable.mentionable_notifier_class
      if notifier_class.column_names.include?('mentioned_user_id')
        notifier_class.create(mentioned_user: self)
      end
    end
  end

  def destroy_notifier
    if mentionable.respond_to?(:mentionable_notifier_class)
      mentionable.mentionable_notifier_class.where(mentioned_user: self).destroy_all
    end
    true
  end
end
