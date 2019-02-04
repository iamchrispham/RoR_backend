# frozen_string_literal: true

module Api
  module V1
    module Files
      class FilesController < ApiController
        
        def create
          aws_response = AwsS3Service.get_presigned_url(params[:file_name], folder_name: params[:folder_name])
          
          if aws_response
            success_response(upload_url: aws_response)
          else
            error_response(t('api.responses.internal_error'), Showoff::ResponseCodes::INTERNAL_ERROR)
          end
        end
      end
    end
  end
end
