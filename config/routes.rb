ZazoStatistics::Application.routes.draw do
  root 'dashboard#index'

  get 'dashboard/users_created'
  get 'dashboard/users_device_platform'
  get 'dashboard/users_status'
  get 'status/new_users_today'
  get 'status/new_verified_users_today'

  resources :connections
  resources :users do
    member do
      get  :events
      get  :visualization
      get  :request_logs
      post :request_logs
    end
  end

  resources :metrics, only: [:index, :show] do
    post :options, on: :member
    get :view, on: :collection
  end

  resources :messages, only: [:index, :show] do
    get :duplications, on: :collection
  end

  namespace :api do
    namespace :v1 do
      resources :fetch, only: [:show] do
        collection do
          get  ':name' => :show
          get  'users/:name' => :show, prefix: :users
          post 'users/:name' => :show, prefix: :users
        end
      end
    end
  end

  get 'landing' => 'landing#index'
  get 'l/:id' => 'landing#invite'
  get 'privacy' => 'landing#privacy'
  get 'ios' => 'landing#ios_coming_soon'

  get 'digest/open'
  get 'digest/secure'

  post 'dispatch/post_dispatch'

  get 'users/new_connection/:id' => 'users#new_connection'
  get 'users/establish_connection/:id' => 'users#establish_connection'
  get 'users/receive_test_video/:id' => 'users#receive_test_video', as: :receive_test_video
  get 'users/receive_corrupt_video/:id' => 'users#receive_corrupt_video', as: :receive_corrupt_video

  post 'videos/create'
  get 'videos/get'
  get 'videos/delete'

  get 'reg/reg'
  get 'reg/verify_code'
  get 'reg/get_friends'
  get 'reg/debug_get_user'

  post 'notification/set_push_token'
  post 'notification/send_video_received'
  post 'notification/send_video_status_update'
  get 'notification/load_test_send_notification'

  post 'kvstore/set'
  get 'kvstore/get'
  get 'kvstore/get_all'
  get 'kvstore/delete'
  get 'kvstore/load_test_read'
  get 'kvstore/load_test_write'

  get 'kvstore_admin' => 'kvstore_admin#index'
  get 'kvstore_admin/delete_all' => 'kvstore_admin#delete_all'

  get 'version/check_compatibility'

  get 'invite_mockup' => 'invite_mockup#index'
  get 'invite_mockup/user/:id' => 'invite_mockup#user'

  get 'invitation/invite'
  get 'invitation/has_app'

  get 'verification_code/say_code'
  get 'verification_code/call_fallback'

  get 'status', to: 'status#heartbeat'
end
