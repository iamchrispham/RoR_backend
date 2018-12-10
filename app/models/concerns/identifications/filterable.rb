module Identifications
  module Filterable
    extend ActiveSupport::Concern

    #filtering
    included do
      filterrific default_filter_params: {
          sorted_by: 'created_at_desc', with_status: 'all'
      }, available_filters: %w[sorted_by search_query with_status with_type]

      scope :search_query, lambda { |query|
        return nil if query.blank?
        query_string = query.to_s
        Identification.for_term(query_string)
      }

      scope :sorted_by, lambda { |sort_option|
        direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
        case sort_option.to_s
          when /^created_at_/
            order("identifications.created_at #{ direction }")
          when /^updated_at_/
            order("identifications.updated_at #{ direction }")
          when 'user_name'
            ordered_by_user_name
          else
            raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
        end
      }

      scope :with_status, lambda { |query|
        return Identification.all if query.to_sym == :all
        Identification.send(query.to_sym)
      }

      scope :with_type, lambda { |query|
        Identification.for_type(query.to_i)
      }

      def self.options_for_status
        [
            ['All', 'all'],
            ['Verified', 'verified'],
            ['Pending Verification', 'pending_verification'],
            ['Rejected', 'rejected']
        ]
      end

      def self.options_for_sorted_by
        [
            ['User Name', 'user_name'],
            ['Created (newest first)', 'created_at_desc'],
            ['Created (oldest first)', 'created_at_asc'],
            ['Updated (newest first)', 'updated_at_desc'],
            ['Updated (oldest first)', 'updated_at_asc'],
        ]
      end

      def self.options_for_type
        types = []
        IdentificationType.all.each do |type|
          types << [type.name, type.id]
        end
        types
      end
    end

  end
end