crud = [:create, :show, :update, :destroy]
crud_w_index = crud + [:index]

Rails.application.routes.draw do
  use_doorkeeper do
    controllers tokens: 'api/token'
  end

  mount LetterOpenerWeb::Engine, at: '/dev/emails' if Rails.env.development?
  mount Sidekiq::Web => '/dev/queues'
  apipie

  scope module: :application do
    devise_for :users,
               path: 'users',
               skip: [:registrations, :sessions],
               controllers: {
                   passwords: 'application/users/passwords',
                   confirmations: 'application/users/confirmations',
               }

    devise_for :admins,
               path: 'admins',
               skip: [:registrations],
               controllers: {
                   sessions: 'application/admins/admins/sessions',
                   passwords: 'application/admins/admins/passwords',
                   invitations: 'application/admins/admins/invitations'
               }


    devise_for :developers,
               path: 'developers',
               skip: [:registrations],
               controllers: {
                   sessions: 'application/developers/developers/sessions',
                   passwords: 'application/developers/developers/passwords',
               }

    scope :admins, module: :admins do
      get 'dashboard', as: :admin_dashboard, controller: :dashboard, action: :index
    end

    scope :developers, module: :developers do
      get 'dashboard', as: :developer_dashboard, controller: :dashboard, action: :index
    end

    #settings
    namespace :settings, only: [] do
      resource :profile, only: [:edit, :update]
    end

    #admins
    scope module: :admins do
      resources :admins do
        put :activate
        put :deactivate
        put :resend_invitation
      end
    end

    # identifications
    scope module: :identifications do
      resources :identifications, except: [:destroy] do
        put :verify
        put :reject
        put :reset
      end
    end

    # users
    scope module: :users do
      resources :users do
        put :activate
        put :deactivate

        put :suspend
        put :unsuspend

        resources :user_logins, path: :sessions, only: [:destroy]
      end
    end

    #admins
    scope module: :general_notifications do
      resources :general_notifications, path: :notifications, except: [:edit, :update] do
        put :send_notification
      end
    end

    namespace :reports do
      resources :events, only: [:index] do
        put :activate_event
        delete :deactivate_event
        delete :suspend_user
      end

      resources :comments, only: [:index] do
        put :activate_comment
        delete :suspend_user
      end

      resources :users, only: [:index] do
        delete :suspend_user
      end

      resources :timeline_items, only: [:index] do
        put :activate_timeline_item
        delete :suspend_user
      end
    end

    # events
    scope module: :events do
      resources :events do
        put :activate
        put :deactivate
      end
    end

    # events
    scope module: :tickets do
      resources :tickets, only: [:index] do
      end
    end

    # notices
    resources :notices, only: :index

    # terms
    scope module: :terms do
      get :terms, controller: :terms, action: :index
    end

    resource :terms, only: [:index], module: :terms do
      get :privacy_policy
    end

    root to: 'home#index'
    get :login, to: 'home#login'
  end

  namespace :api do
    namespace :v1 do
      scope :configurations, controller: :configurations do
        get :generic
      end

      scope :users, controller: :users, module: :users do
        post :reset_password
        get :email
        get :group
        post :merge
      end

      #users routes
      resources :users, module: :users, only: (crud - [:destroy]) do
        collection do
          resources :tags, only: :index
        end

        post :password
        post :send_verification_email
        put :facebook_friends
        put :contacts
        post :invite
        put :facebook_events

        resource :notification_settings, only: [:update]

        resources :devices, only: [:create, :destroy], param: :uuid

        resources :notifications, only: (crud_w_index - [:create])
        resource :identifications, only: [:create, :destroy]

        resources :friends, only: [:index]
        resource :friends, only: [:destroy]
        resources :friend_requests, only: [:index, :create] do
          put :accept
          delete :reject
          delete :cancel
        end

        resources :events, only: [:index]

        resource :reports, only: [:create]

        resources :payment_methods, only: (crud_w_index - [:update, :show]) do
          put :default
        end

        resources :payout_methods, only: (crud_w_index - [:update, :show]) do
          put :default
        end
      end

      #search routes
      scope :search, module: :search do
        resource :locations, controller: :locations, only: [:create]
        resource :lookup, controller: :lookups, only: [:create]
        resource :tags, only: [:create]
        resource :users, only: [:create]
      end

      scope module: :tags do
        resources :tags, only: [:index] do
          resources :events, only: [:index]
        end
      end

      scope :locations, module: :locations do
        resources :events, only: [:create]
      end

      scope module: :events do
        resources :events, only: [:index, :create, :show, :destroy, :update] do
          resource :tickets, module: :tickets, only: [] do
            get :view
          end

          resources :friends, module: :friends, only: [] do
            collection do
              resources :uninvited, only: :index
            end
          end

          resources :contacts, module: :contacts, only: [] do
            collection do
              resources :invites, only: :create
            end
          end

          resources :attendees, only: [:index, :update, :create] do
            resources :contributions, only: [:create]
            resource :contributions, only: [] do
              post :price
            end
            resources :requests, only: [] do
              put :accept
              delete :reject
            end
          end

          scope module: :timelines do
            resources :timeline, only: [:index, :create, :destroy] do
              resource :reports, only: [:create]
              resource :likes, only: [:create, :destroy]

              resources :comments, module: :comments, only: [:index, :create, :update, :destroy] do
                resource :reports, only: [:create]
              end
            end
          end

          resource :shares, only: [:create]

          resource :reports, only: [:create]
        end
      end

      # conversation routes
      resources :conversations, module: :conversations, only: (crud_w_index - [:update]) do
        resources :messages, only: (crud_w_index - [:update]) do
          resources :statuses, only: [:index, :show, :update], controller: :message_statuses
        end

        resources :participants, only: [:destroy, :index]
        post :mute
        delete :mute, action: :unmute
      end

      scope :home, module: :home do
        resources :friends, only: [:create]
        resources :groups, only: [:create]
        resources :featured, only: [:create]
      end

      scope module: :feed do
        resources :feed, only: [:index]
      end
    end
  end
end