Rails.application.routes.draw do
  apipie

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'test', to: 'tests/index'
    end

    namespace :v2 do
      get 'test', to: 'tests/index'
    end
  end
end
