# frozen_string_literal: true

module Application
  module Admins
    class OfferApprovalsController < WebController
      before_action :authenticate_admin!

      def index
        @objects =
          group.offer_approvals.includes(:special_offer).order(created_at: :desc).paginate(page: params[:page])
      end

      def approve
        offer_approval.update(active: true)

        redirect_to admins_college_offer_approvals_path(group),
                    notice: t('views.admins.offer_approvals.status.approved')
      end

      def disapprove
        offer_approval.update(active: false)

        redirect_to admins_college_offer_approvals_path(group),
                    notice: t('views.admins.offer_approvals.status.disapproved')
      end

      private

      def offer_approval
        @offer_approval ||= OfferApproval.find_by(params[:id])
      end

      def group
        @group ||= Group.find(params[:college_id])
      end
    end
  end
end
