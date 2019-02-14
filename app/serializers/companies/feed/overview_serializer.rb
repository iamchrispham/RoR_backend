module Companies
  module Feed
    class OverviewSerializer < ApiSerializer
      attributes :id, :type, :user_id, :title, :description, :phone_number, :email, :facebook_profile_link, :linkedin_profile_link, 
                :instagram_profile_link, :snapchat_profile_link, :website_link, :location, :categories
      
      def type
        object.class.name
      end
    end
  end
end