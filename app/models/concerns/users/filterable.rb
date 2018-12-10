module Users
  module Filterable
    extend ActiveSupport::Concern

    #filtering
    included do
      filterrific default_filter_params: {sorted_by: 'name'}, available_filters: %w[sorted_by search_query by_gender by_type by_age_range]

      scope :search_query, lambda {|query|
        return nil if query.blank?
        query_string = query.to_s
        User.for_term(query_string)
      }

      scope :sorted_by, lambda {|sort_option|
        direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
        case sort_option.to_s
        when /^created_at_/
          order("users.created_at #{ direction }")
        when /^updated_at_/
          order("users.updated_at #{ direction }")
        when 'name'
          ordered_by_name
        when 'ordered_by_number_hosting'
          ordered_by_number_attending
        when 'ordered_by_number_attending'
          ordered_by_number_attending
        when 'ordered_by_reports'
          ordered_by_reports
        else
          raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
        end
      }

      scope :by_gender, lambda { |gender|
        case gender.to_s

        when 'all'
          all
        when 'unknown'
          where(gender: nil)
        else
          where(gender: gender)
        end
      }

      scope :by_type, lambda { |type|
        case type.to_s
        when 'all'
          all
        when 'personal'
          personal
        when 'group'
          business
        else
          raise(ArgumentError, "Invalid type option: #{ type.inspect }")
        end
      }

      scope :by_age_range, lambda { |age_range|
        if age_range.to_s.eql?('all')
          all
        else
          joins(:user_age_range).where(user_age_ranges: { id: age_range })
        end
      }

      def self.options_for_sorted_by
        [
            ['Name', 'name'],
            ['Total Hosting', 'ordered_by_number_hosting'],
            ['Total Attending', 'ordered_by_number_attending'],
            ['Total Reports', 'ordered_by_reports'],
            ['Sign Up Date (newest first)', 'created_at_desc'],
            ['Sign Up Date (oldest first)', 'created_at_asc'],
            ['Updated Date (newest first)', 'updated_at_desc'],
            ['Updated Date (oldest first)', 'updated_at_asc'],
        ]
      end

      def self.options_for_gender
        [
            ['All', 'all'],
            ['Male', 'male'],
            ['Female', 'female'],
            ['Not Specified', 'unknown']
        ]
        end

      def self.options_for_type
        [
            ['All', 'all'],
            ['Personal', 'personal'],
            ['Group', 'group']
        ]
      end

      def self.options_for_age_range
        UserAgeRange.all.uniq.map do |range|
          [range.name, range.id]
        end.to_a.unshift(['All', 'all'])
      end
    end

  end
end