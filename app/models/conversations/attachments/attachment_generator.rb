# frozen_string_literal: true

module Conversations
  module Attachments
    class AttachmentGenerator < ApiService
      include Api::ErrorHelper

      def attachment_for_type(type, attachment_params)
        case type
        when 'location'
          location_params = attachment_params[:location]
          if location_params.blank?
            register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.missing_parameter', param: 'location')) && (return nil)
          else
            latitude = location_params[:latitude]
            longitude = location_params[:longitude]
            if latitude.blank? || longitude.blank?
              register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.missing_parameter', param: 'latitude or longitude')) && (return nil)
            else
              attachment = Conversations::Attachments::LocationAttachment.new(location_params)
              if attachment.save
                attachment
              else
                register_error(Showoff::ResponseCodes::INTERNAL_ERROR, attachment.errors.full_messages.to_sentence) && (return nil)
              end
            end
          end

        when 'image'
          image_params = attachment_params[:image]
          image_url = image_params[:image_url] unless image_params.blank?
          image_file = image_params[:image_file] unless image_params.blank?

          if image_url.blank? && image_data.blank? && image_file.blank?
            register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.missing_parameter', param: 'image_url or image_data or image_file')) && (return nil)
          else
            attachment = Conversations::Attachments::ImageAttachment.new
            attachment.uploaded_url = image_url if image_url.present?
            if attachment.save
              if image_url
                image_service = Showoff::Services::ImageService.new(klass: attachment.class.to_s, id: attachment.id, attribute: :image)
                image_service.import_from_url(image_url)
              elsif image_file
                attachment.image = image_file
                attachment.save
              end
              attachment
            else
              register_error(Showoff::ResponseCodes::INTERNAL_ERROR, attachment.errors.full_messages.to_sentence) && (return nil)
            end
          end
        when 'video'
          video_params = attachment_params[:video]
          video_url = video_params[:video_url] unless video_params.blank?
          video_file = video_params[:video_file] unless video_params.blank?

          if video_url.blank? && video_file.blank?
            register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.missing_parameter', param: 'video_url or video_file')) && (return nil)
          else
            attachment = Conversations::Attachments::VideoAttachment.new
            attachment.uploaded_url = video_url if video_url.present?
            if attachment.save
              if video_url
                video_service = Showoff::Services::VideoService.new(klass: attachment.class.to_s, id: attachment.id, attribute: :video)
                video_service.import_from_url(video_url)
              elsif video_file
                attachment.video = video_file
                attachment.save
              end
              attachment
            else
              register_error(Showoff::ResponseCodes::INTERNAL_ERROR, attachment.errors.full_messages.to_sentence) && (return nil)
            end
          end

        end
      end
    rescue StandardError => e
      report_error(e)
      register_error(Showoff::ResponseCodes::INTERNAL_ERROR, I18n.t('api.responses.conversations.messages.attachments.unknown_error_occurred'))
    end
  end
end
