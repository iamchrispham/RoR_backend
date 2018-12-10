module Showoff
  module Concerns
    module Slugable
      extend ActiveSupport::Concern

      included do
        before_save :ensure_slug
      end


      def ensure_slug
        if slug.blank?
          self.slug = generate_slug
        end
      end

      def generate_slug
        loop do
          slug = SecureRandom.hex(6)
          break slug unless self.class.find_by(slug: slug)
        end
      end
    end
  end
end