module Events
  module Filterable
    extend ActiveSupport::Concern

    #filtering
    included do
      filterrific default_filter_params: {sorted_by: 'name'}, available_filters: %w[sorted_by search_query by_type by_status by_age by_visibility by_chat by_timeline by_forwarding by_contributions by_tickets]

      scope :search_query, lambda {|query|
        return nil if query.blank?
        query_string = query.to_s
        Event.for_term(query_string)
      }

      scope :sorted_by, lambda {|sort_option|
        direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
        case sort_option.to_s
        when /^created_at_/
          order("events.created_at #{ direction }")
        when /^updated_at_/
          order("events.updated_at #{ direction }")
        when 'name'
          ordered_by_name
        when 'total_attending'
          ordered_by_popular
        when 'upcoming'
          order_to_now
        when 'ordered_by_reports'
          ordered_by_reports
        else
          raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
        end
      }

      scope :by_type, lambda {|type|
        case type.to_s
        when 'all'
          all
        when 'personal'
          with_personal
        when 'group'
          with_group
        else
          raise(ArgumentError, "Invalid type option: #{ type.inspect }")
        end
      }

      scope :by_status, lambda {|type|
        case type.to_s
        when 'all'
          all
        when 'active'
          where(active: true)
        when 'cancelled'
          where(active: false)
        else
          raise(ArgumentError, "Invalid type option: #{ type.inspect }")
        end
      }

      scope :by_age, lambda {|type|
        case type.to_s
        when 'all'
          all
        when 'eighteen_plus'
          where(eighteen_plus: true)
        when 'not_eighteen_plus'
          where(eighteen_plus: false)
        else
          raise(ArgumentError, "Invalid by_age option: #{ type.inspect }")
        end
      }

      scope :by_chat, lambda {|type|
        case type.to_s
        when 'all'
          all
        when 'enabled'
          where(allow_chat: true)
        when 'disabled'
          where(allow_chat: false)
        else
          raise(ArgumentError, "Invalid by_age option: #{ type.inspect }")
        end
      }

      scope :by_timeline, lambda {|type|
        case type.to_s
        when 'all'
          all
        when 'enabled'
          where(show_timeline: true)
        when 'disabled'
          where(show_timeline: false)
        else
          raise(ArgumentError, "Invalid by_timeline option: #{ type.inspect }")
        end
      }

      scope :by_forwarding, lambda {|type|
        case type.to_s
        when 'all'
          all
        when 'enabled'
          where(event_forwarding: true)
        when 'disabled'
          where(event_forwarding: false)
        else
          raise(ArgumentError, "Invalid by_forwarding option: #{ type.inspect }")
        end
      }

      scope :by_contributions, lambda {|type|
        case type.to_s
        when 'all'
          all
        when 'enabled'
          with_contributions
        when 'disabled'
          without_contributions
        else
          raise(ArgumentError, "Invalid by_forwarding option: #{ type.inspect }")
        end
      }


      scope :by_tickets, lambda {|type|
        case type.to_s
        when 'all'
          all
        when 'enabled'
         with_tickets
        when 'disabled'
          without_tickets
        else
          raise(ArgumentError, "Invalid by_forwarding option: #{ type.inspect }")
        end
      }



      scope :by_visibility, lambda {|type|
        case type.to_s
        when 'all'
          all
        when 'public'
          where(private_event: false)
        when 'private'
          where(private_event: true)
        else
          raise(ArgumentError, "Invalid by_visibility option: #{ type.inspect }")
        end
      }

      def self.options_for_sorted_by
        [
            ['Name', 'name'],
            ['Total Attending', 'total_attending'],
            ['Upcoming', 'upcoming'],
            ['Total Reports', 'ordered_by_reports'],
            ['Created (newest first)', 'created_at_desc'],
            ['Created (oldest first)', 'created_at_asc'],
            ['Updated (newest first)', 'updated_at_desc'],
            ['Updated (oldest first)', 'updated_at_asc'],
        ]
      end

      def self.options_for_type
        [
            ['All', 'all'],
            ['Personal', 'personal'],
            ['Group', 'group']
        ]
      end

      def self.options_for_chat
        [
            ['All', 'all'],
            ['Chat Enabled', 'enabled'],
            ['Chat Disabled', 'disabled']
        ]
      end

      def self.options_for_timeline
        [
            ['All', 'all'],
            ['Timeline Enabled', 'enabled'],
            ['Timeline Disabled', 'disabled']
        ]
      end

      def self.options_for_forwarding
        [
            ['All', 'all'],
            ['Forwarding Enabled', 'enabled'],
            ['Forwarding Disabled', 'disabled']
        ]
      end

      def self.options_for_tickets
        [
            ['All', 'all'],
            ['Tickets Enabled', 'enabled'],
            ['Tickets Disabled', 'disabled']
        ]
      end

      def self.options_for_contributions
        [
            ['All', 'all'],
            ['Contributions Enabled', 'enabled'],
            ['Contributions Disabled', 'disabled']
        ]
      end

      def self.options_for_status
        [
            ['All', 'all'],
            ['Active', 'active'],
            ['Cancelled', 'cancelled']
        ]
      end


      def self.options_for_age
        [
            ['All', 'all'],
            ['Eighteen Plus', 'eighteen_plus'],
            ['Not Eighteen Plus', 'not_eighteen_plus'],
        ]
      end

      def self.options_for_visibility
        [
            ['All', 'all'],
            ['Public', 'public'],
            ['Private', 'private']
        ]
      end


    end

  end
end