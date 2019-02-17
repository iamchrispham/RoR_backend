module Api
  module V1
    module Groups
      class InvitationsController < ApiController
        before_filter :set_group
        before_filter :set_invitation, only: [:accept, :reject]

        def index
          invitation = @group.group_invitations
          invitation = invitation.for_term(params[:term]) unless params[:term].blank?

          success_response(invitation.includes([:user]).limit(limit).offset(offset))
        end

        def create
          @invitation = @group.group_invitations.new()
          @invitation.user = current_api_user
          if @invitation.save
            success_response(
              invitation: serialized_resource(
                @invitation,
                ::Groups::InvitationSerializer
              )
            )
          else
            active_record_error_response(@invitation)
          end
        end

        def accept
          @invitation.accept!
          success_response(request: serialized_resource(@invitation, ::Groups::InvitationSerializer))
        end

        def reject
          @invitation.reject!
          success_response(invitations: serialized_resource(@invitations, ::Groups::InvitationSerializer))
        end

        def set_group
          @group ||= Group.find_by(id: params[:group_id] || params[:id])
        end

        def set_invitation
          @invitation = GroupInvitation.find_by(id: params[:invitation_id] || params[:id])
        end
      end
    end
  end
end
