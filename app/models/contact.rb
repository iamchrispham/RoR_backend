# frozen_string_literal: true

class Contact < ActiveRecord::Base
  include Showoff::Concerns::Imagable
  include Indestructable

  belongs_to :contactable, polymorphic: true

  validates :details,
            format: { with: General::PHONE_FORMAT_REGEXP },
            length: { minimum: 7, maximum: 13 },
            allow_blank: true,
            if: proc { |c| c.category == 'phone' }

  validates :details,
            url: { allow_blank: true },
            if: proc { |c| c.category == 'url' }

  validates :details, uniqueness: { scope: %i[id category] }

  validates_with EmailAddress::ActiveRecordValidator,
                 field: :details,
                 if: proc { |c| c.category == 'email' }
end
