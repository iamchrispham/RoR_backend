# frozen_string_literal: true

module Groups
  class CreateMembership < ActiveInteraction::Base
    object :user
    object :group

    validate :college_email_domain_match, if: :group_auto_acceptance?

    def execute
      membership = Membership.find_or_initialize_by(inputs)
      membership.active = true if group_auto_acceptance?

      if membership.save
        membership
      else
        errors.merge!(membership.errors)
      end
    end

    private

    def college_email_domain_match
      return unless group.college?
      return if EmailAddress.matches?(user.email, group.email_domain)

      errors.add(:user_email_domain, 'don\'t match college domain')
    end

    def group_auto_acceptance?
      group.acceptance_mode == 'automatic'
    end
  end
end
