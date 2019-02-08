# frozen_string_literal: true

module Api
  module V1
    module Groups
      class PostsController < ApiController
        before_action :check_group_presence
        before_action :check_post_presence, only: %i[show update destroy]
        before_action :check_group_ownership, only: %i[create update destroy]

        def index
          posts = group.posts.active

          success_response(
            count: posts.count,
            posts: serialized_resource(posts.order(id: :desc).limit(limit).offset(offset), ::Posts::OverviewSerializer)
          )
        end

        def show
          success_response(
            post: serialized_resource(post, ::Posts::OverviewSerializer)
          )
        end

        def create
          post = group.posts.build(post_params)
          if post.save
            success_response(post: serialized_resource(post, ::Posts::OverviewSerializer))
          else
            active_record_error_response(post)
          end
        end

        def update
          if post.update(post_params)
            success_response(post: serialized_resource(post, ::Posts::OverviewSerializer))
          else
            active_record_error_response(post)
          end
        end

        def destroy
          if post.destroy
            success_response(
              posts: serialized_resource(group.posts.active, ::Posts::OverviewSerializer)
            )
          else
            active_record_error_response(post)
          end
        end

        private

        def check_group_presence
          group_not_found_error if group.blank?
        end

        def check_post_presence
          post_not_found_error if post.blank?
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

        def post
          @post ||= group.posts.active.where(id: params[:post_id] || params[:id]).first
        end

        def post_not_found_error
          @post_not_found_error ||=
            error_response(t('api.responses.posts.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end

        def post_params
          params.require(:post).permit!
        end
      end
    end
  end
end
