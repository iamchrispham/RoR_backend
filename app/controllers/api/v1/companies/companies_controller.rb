module Api
  module V1
    module Companies
      class CompaniesController < ApiController
        def index
          success_response(
            count: current_api_user.companies.count,
            companies: current_api_user.companies.limit(limit).offset(offset).order(created_at: :desc).map { |company| company.cached(current_api_user, type: :feed) }
          )
        end

        def show
          show_company = Company.find_by(id: params[:id])
          if show_company
            success_response(company: show_company.cached(current_api_user, type: :public))
          else
            error_response((t 'api.responses.companies.not_found'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          end
        end

        def create
          if Company.find_by(title: company_params[:title])
            error_response((t 'api.responses.companies.company_exists'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          else
            company = current_api_user.companies.new(company_params.except(:media_items))
            if company.save
              success_response(company: company.cached(current_api_user, type: :public))              
            else
              active_record_error_response(company)
            end
          end
        end
        
        def update
          update_company = current_api_user.companies.find_by(id: params[:id])
          
          if update_company
            if update_company.update_attributes(company_params.except(:image_url, :image_data))
              success_response(company: update_company.cached(current_api_user, type: :public))              
            else
              active_record_error_response(update_company)
            end
          else
            error_response((t 'api.responses.companies.not_found'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          end
        end

        def destroy
          deleted_company = current_api_user.companies.find_by(id: params[:id])
          if deleted_company
            if deleted_company&.destroy
              success_response(destroyed: true)
            else
              active_record_error_response(update_company)
            end
          else
            error_response((t 'api.responses.companies.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
          end
        end

        private

        def process_images(company)
          if company_params[:image_url] || company_params[:image_data]
            Showoff::Workers::ImageWorker.perform_async('Company', company.id, url: company_params[:image_url], data: company_params[:image_data])
          end
        end

        def company_params
          params.require(:company).permit(:title, :description, :phone_number, :email, :facebook_profile_link, 
            :linkedin_profile_link, :instagram_profile_link, :snapchat_profile_link, :website_link, :location,
            :categories)
        end
      end
    end
  end
end
