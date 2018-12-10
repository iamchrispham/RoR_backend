module Showoff
  module Services
    class FacebookService < Base
      def friends(klass: User, attribute: :facebook_uid)
        klass.where(attribute => friend_ids)
      end

      private

      def friend_ids
        friend_ids = []
        connections = graph.get_connections('me', 'friends')
        friend_ids << parse_collection_key(connections, 'id')
        until (connections = connections.next_page).nil?
          friend_ids << parse_collection_key(connections, 'id')
        end
        friend_ids.flatten
      end

      def parse_collection_key(collection, key = 'id')
        collection.map { |c| c[key] }
      end

      def graph
        access_token = @params[:facebook_access_token]
        @graph ||= Koala::Facebook::API.new(access_token)
      end
    end
  end
end
