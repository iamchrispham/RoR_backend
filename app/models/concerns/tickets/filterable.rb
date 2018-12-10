module Tickets
  module Filterable
    extend ActiveSupport::Concern

    #filtering
    included do
      filterrific default_filter_params: {sorted_by: 'url'}, available_filters: %w[sorted_by search_query by_status]

      scope :search_query, lambda {|query|
        return nil if query.blank?
        query_string = query.to_s
        EventTicketDetail.for_term(query_string)
      }

      scope :sorted_by, lambda {|sort_option|
        direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
        case sort_option.to_s
        when /^created_at_/
          order("event_ticket_details.created_at #{ direction }")
        when /^updated_at_/
          order("event_ticket_details.updated_at #{ direction }")
        when 'url'
          ordered_by_url
        when 'name'
          ordered_by_url
        when 'total_views'
          ordered_by_views
        else
          raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
        end
      }

      scope :by_status, lambda {|type|
        case type.to_s
        when 'all'
          all
        when 'active'
          where(active: true)
        when 'removed'
          where(active: false)
        else
          raise(ArgumentError, "Invalid type option: #{ type.inspect }")
        end
      }


      def self.options_for_sorted_by
        [
            ['Url', 'url'],
            ['Total Views', 'total_views'],
            ['Created (newest first)', 'created_at_desc'],
            ['Created (oldest first)', 'created_at_asc'],
            ['Updated (newest first)', 'updated_at_desc'],
            ['Updated (oldest first)', 'updated_at_asc'],
        ]
      end

      def self.options_for_status
        [
            ['All', 'all'],
            ['Active', 'active'],
            ['Removed', 'removed']
        ]
      end

    end

  end
end