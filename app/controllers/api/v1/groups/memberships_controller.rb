# frozen_string_literal: true

module Api
  module V1
    module Groups
      class MembershipsController < ApiController
        before_action :check_group_presence
        before_action :check_ownership, only: %i[approve disapprove]
        before_action :check_approved_member_presence, only: :disapprove
        before_action :check_unapproved_member_presence, only: :approve

        def index
          members =
            User.joins(:memberships).where(memberships: { group: group }).order(id: :desc).limit(limit).offset(offset)
          success_response(
            count: members.count,
            members: serialized_resource(members, ::Users::PublicSerializer)
          )
        end

        def approved
          members =
            User.joins(:approved_memberships)
                .where(memberships: { group: group })
                .order(id: :desc)
                .limit(limit)
                .offset(offset)
          success_response(
            count: members.count,
            members: serialized_resource(members, ::Users::PublicSerializer)
          )
        end

        def unapproved
          members =
            User.joins(:unapproved_memberships)
                .where(memberships: { group: group })
                .order(id: :desc)
                .limit(limit)
                .offset(offset)
          success_response(
            count: members.count,
            members: serialized_resource(members, ::Users::PublicSerializer)
          )
        end

        def create
          outcome = ::Groups::CreateMembership.run(group: group, user: current_api_user)
          if outcome.valid?
            success_response(member: serialized_resource(outcome.result.user, ::Users::PublicSerializer))
          else
            active_record_error_response(outcome)
          end
        end

        def approve
          membership = unpproved_member.unapproved_memberships.find_or_initialize_by(group: group)
          if membership.update(active: true)
            success_response(
              members: serialized_resource(group.approved_active_members, ::Users::PublicSerializer)
            )
          else
            active_record_error_response(membership)
          end
        end

        def disapprove
          if approved_member.approved_memberships.destroy_all
            success_response(
              members: serialized_resource(group.approved_active_members, ::Users::PublicSerializer)
            )
          else
            active_record_error_response(approved_member)
          end
        end

        def status
          membership = Membership.where(group: group, user: current_api_user).first
          success_response(membership: serialized_resource(membership, ::Groups::MembershipSerializer))
        end

        private

        def check_group_presence
          not_found_error if group.blank?
        end

        def check_ownership
          not_found_error if group.owner != current_api_user
        end

        def group
          @group ||= Group.active.find_by(id: params[:group_id] || params[:id])
        end

        def not_found_error
          error_response(t('api.responses.groups.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end

        def check_approved_member_presence
          member_not_found_error if approved_member.blank?
        end

        def check_unapproved_member_presence
          member_not_found_error if unpproved_member.blank?
        end

        def approved_member
          @approved_member ||=
            group.approved_active_members.where(id: params[:user_id]).first
        end

        def unpproved_member
          @unpproved_member ||= group.unapproved_active_members.where(id: params[:user_id]).first
        end

        def member_not_found_error
          @member_not_found_error ||=
            error_response(t('api.responses.members.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end
      end
    end
  end
end
