class ApiSerializer < ActiveModel::Serializer
  include Showoff::Helpers::SerializationHelper
  include Showoff::Helpers::CurrentAPIUserHelper
  include MoneyRails::ActionViewExtension
  include ActionView::Helpers::NumberHelper

  def tags
    if object.respond_to?(:tagged_objects)
      key = "#{object.class.to_s.downcase}_#{object.id}_tags"
      cache = AutoExpireCache.new

      items = cache[key]
      if items.blank?
        tags = object.tagged_objects.includes(:tagged_attribute, :tag).group_by { |t| t.tagged_attribute.attribute_name }
        tags = tags.map do |attribute, tags|
          { attribute => serialized_resource(tags, ::Tags::OverviewSerializer) }
        end.reduce({}, :merge)
        cache[key] = tags.as_json
      end

      JSON.parse(cache[key])
    else
      raise NoMethodError, "#{object.class.name} has no tagged objects association."
    end
  end

  def mentions
    if object.respond_to?(:mentioned_users)
      key = "#{object.class.to_s.downcase}_#{object.id}_mentions"
      cache = AutoExpireCache.new

      items = cache[key]
      if items.blank?
        mentions = object.mentioned_users.includes(:mentioned_attribute, :mentioned_user).group_by { |m| m.mentioned_attribute.attribute_name }
        mentions = mentions.map do |attribute, mentions|
          { attribute => serialized_resource(mentions, MentionedUser::OverviewSerializer) }
        end.reduce({}, :merge)

        cache[key] = mentions.as_json
      end
      JSON.parse(cache[key])
    else
      raise NoMethodError, "#{object.class.name} has no mentioned_users association."
    end
  end

  def instance_user
    instance_options[:user]
  end

  def instance_currency
    instance_options[:currency]
  end

end
