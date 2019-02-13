module Companies
  class OverviewSerializer < ApiSerializer
    attributes :id, :title, :description, :phone_number, :email, :facebook_profile_link, :linkedin_profile_link, 
               :instagram_profile_link, :snapchat_profile_link, :website_link, :location, :categories
  end
end