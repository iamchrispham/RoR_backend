# frozen_string_literal: true

module Api
  module V1
    module Groups
      class ContactsController < ApiController
        before_action :check_group_presence
        before_action :check_group_ownership, only: %i[create update destroy]

        def index
          contacts = group.contacts.active.order(id: :desc).limit(limit).offset(offset)

          success_response(
            count: contacts.count,
            contacts: serialized_resource(contacts, ::Contacts::OverviewSerializer)
          )
        end

        def show
          success_response(
            contact: serialized_resource(contact, ::Contacts::OverviewSerializer)
          )
        end

        def create
          contact = group.contacts.build(contact_params)
          if contact.save
            success_response(contact: serialized_resource(contact, ::Contacts::OverviewSerializer))
          else
            active_record_error_response(contact)
          end
        end

        def update
          if contact.update(contact_params)
            success_response(contact: serialized_resource(contact, ::Contacts::OverviewSerializer))
          else
            active_record_error_response(contact)
          end
        end

        def destroy
          if contact.destroy
            success_response(
              contacts: serialized_resource(group.contacts.active, ::Contacts::OverviewSerializer)
            )
          else
            active_record_error_response(contact)
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

        def contact
          @contact ||= group.contacts.active.where(id: params[:contact_id] || params[:id]).first
        end

        def contact_not_found_error
          @contact_not_found_error ||=
            error_response(t('api.responses.contacts.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end

        def contact_params
          params.require(:contact).permit!
        end
      end
    end
  end
end
