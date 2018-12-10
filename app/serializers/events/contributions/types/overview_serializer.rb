module Events
  module Contributions
    module Types
      class OverviewSerializer < ApiSerializer
        attributes :id, :name, :slug, :cta_title, :cta_description, :change_amount_title, :change_amount_description

        def cta_description
          return object.cta_description if instance_contribution_details.blank?
          return instance_contribution_details.cta_description
        end


        private
        def instance_contribution_details
          instance_options[:contribution_details]
        end

      end
    end
  end
end
