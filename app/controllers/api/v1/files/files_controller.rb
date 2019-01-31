# frozen_string_literal: true

module Api
  module V1
    module Files
      class FilesController < ApiController
        
        def create
          aws_response = AwsS3Service.get_presigned_url(params[:file_name], folder_name: params[:folder_name])
          upload_url, service_info = aws_response.split('?')
          
          if upload_url
            success_response(upload_url: upload_url, service_info: service_info)
          else
            error_response(t('api.responses.internal_error'), Showoff::ResponseCodes::INTERNAL_ERROR)
          end
        end
      end
    end
  end
end
