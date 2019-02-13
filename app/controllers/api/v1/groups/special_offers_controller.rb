# frozen_string_literal: true

module Api
  module V1
    module Groups
      class SpecialOffersController < ApiController
        before_action :check_group_presence
        before_action :check_group_ownership, only: %i[approved unapproved past approve disapprove destroy]

        before_action :check_approved_special_offer_presence, only: %i[show disapprove]
        before_action :check_unapproved_special_offer_presence, only: :approve

        before_action :check_special_offer_presence, only: %i[like unlike update]

        def approved
          offers = group.approved_active_offers

          success_response(
            count: offers.count,
            special_offers: serialized_resource(
              offers.order(id: :desc).limit(limit).offset(offset), ::SpecialOffers::OverviewSerializer
            )
          )
        end

        def past
          offers = group.approved_past_active_offers

          success_response(
            count: offers.count,
            special_offers: serialized_resource(
              offers.order(id: :desc).limit(limit).offset(offset), ::SpecialOffers::OverviewSerializer
            )
          )
        end

        def unapproved
          offers = group.unapproved_active_offers

          success_response(
            count: offers.count,
            special_offers: serialized_resource(
              offers.order(id: :desc).limit(limit).offset(offset), ::SpecialOffers::OverviewSerializer
            )
          )
        end

        def active_today
          offers = group.approved_active_offers.active_today

          success_response(
            count: offers.count,
            special_offers: serialized_resource(
              offers.order(id: :desc).limit(limit).offset(offset), ::SpecialOffers::OverviewSerializer
            )
          )
        end

        def upcoming
          offers = group.approved_active_offers.upcoming

          success_response(
            count: offers.count,
            special_offers: serialized_resource(
              offers.order(id: :desc).limit(limit).offset(offset), ::SpecialOffers::OverviewSerializer
            )
          )
        end

        def most_liked
          offers = SpecialOffer.most_liked(group.id)

          success_response(
            # FIXME: fix the counter
            # count: offers.count,
            special_offers: serialized_resource(offers.limit(limit).offset(offset), ::SpecialOffers::OverviewSerializer)
          )
        end

        def show
          success_response(
            special_offer: serialized_resource(approved_special_offer, ::SpecialOffers::OverviewSerializer)
          )
        end

        def create
          offer = SpecialOffer.new(special_offer_params)
          if offer.save
            success_response(special_offer: serialized_resource(offer, ::SpecialOffers::OverviewSerializer))
          else
            active_record_error_response(offer)
          end
        end

        def update
          if special_offer.update(special_offer_params)
            success_response(special_offers: serialized_resource(special_offer, ::SpecialOffers::OverviewSerializer))
          else
            active_record_error_response(special_offer)
          end
        end

        def approve
          offer_approval = unpproved_special_offer.approved_offers.build(user: group.owner, group: group, active: true)
          if offer_approval.save
            success_response(
              special_offers: serialized_resource(group.approved_active_offers, ::SpecialOffers::OverviewSerializer)
            )
          else
            active_record_error_response(offer_approval)
          end
        end

        def disapprove
          if approved_special_offer.approved_offers.destroy_all
            success_response(
              special_offers: serialized_resource(group.approved_active_offers, ::SpecialOffers::OverviewSerializer)
            )
          else
            active_record_error_response(approved_special_offer)
          end
        end

        def destroy
          if approved_special_offer.destroy
            success_response(
              special_offers: serialized_resource(group.approved_active_offers, ::SpecialOffers::OverviewSerializer)
            )
          else
            active_record_error_response(approved_special_offer)
          end
        end

        def like
          like = current_api_user.liked_offers.build(group: group, special_offer: special_offer)
          if like.save
            success_response(
              special_offers: serialized_resource(
                current_api_user.liked_special_offers, ::SpecialOffers::OverviewSerializer
              )
            )
          else
            active_record_error_response(like)
          end
        end

        def unlike
          like = current_api_user.liked_offers.where(group: group, special_offer: special_offer).first
          if like.destroy
            success_response(
              special_offers: serialized_resource(
                current_api_user.liked_special_offers, ::SpecialOffers::OverviewSerializer
              )
            )
          else
            active_record_error_response(like)
          end
        end

        private

        def check_group_presence
          group_not_found_error if group.blank?
        end

        def check_group_ownership
          group_not_found_error if group.owner != current_api_user
        end

        def group
          @group ||= Group.active.find_by(id: params[:group_id])
        end

        def group_not_found_error
          @group_not_found_error ||=
            error_response(t('api.responses.groups.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end

        def check_approved_special_offer_presence
          special_offers_not_found_error if approved_special_offer.blank?
        end

        def check_unapproved_special_offer_presence
          special_offers_not_found_error if unpproved_special_offer.blank?
        end

        def check_special_offer_presence
          special_offers_not_found_error if special_offer.blank?
        end

        def approved_special_offer
          @approved_special_offer ||=
            group.approved_active_offers.where(id: params[:special_offer_id] || params[:id]).first
        end

        def unpproved_special_offer
          @unpproved_special_offer ||= group.unapproved_active_offers.where(id: params[:special_offer_id]).first
        end

        def special_offer
          @special_offer ||= SpecialOffer.active.find_by(id: params[:special_offer_id] || params[:id])
        end

        def special_offers_not_found_error
          @special_offers_not_found_error ||=
            error_response(t('api.responses.special_offers.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end

        def special_offer_params
          params.require(:special_offer).permit!
        end
      end
    end
  end
end
