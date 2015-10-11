Ludum::Application.routes.draw do

  post '/rate' => 'rater#create', :as => 'rate'
  resources :password_resets
  get "admin/:action", as: :admin, controller: :admin
  resources :categories do
    resources :courses
  end

  get "errors/error_404", as: :not_found
  get "errors/error_500", as: :error
  get "search/khan"
  get "search/youtube"
  get "search/educreations"

  get "funds/how", as: :how_to_fund
  resources :funds do
    resources :orders
    resources :comments
    resources :updates
  end

  get "orders/postfill" => "orders#postfill", as: :postfill

  resources :orders
  resources :comments, only: [:destroy]
  resources :wish_votes

  resources :wishes do
    resources :comments
  end

  resources :user_answers

  resources :enrollments

  get 'questions/:id/copy' => 'questions#copy', as: :copy_question
  post 'questions/:question_id/answer' => 'questions#answer', as: :answer

  resources :completions

  get 'logout' => 'sessions#destroy', :as => :logout

  get 'login' => 'sessions#new', :as => :login

  get "subsections/:subsection_id/complete" => 'completions#complete', as: :complete

  get '/auth/:provider/callback', to: 'sessions#oauth'
  resources :sessions

  get 'users/payment_prefill' => 'users#prefill', as: :prefill_user
  get 'users/payment_postfill' => 'users#postfill', as: :postfill_user
  get 'users/payment', as: :payment
  post 'users/change_password', as: :change_password

  get 'signup' => 'users#new', :as => :signup

  get 'user/edit' => 'users#edit', :as => :edit_current_user

  get 'users/test_email'
  get 'users/request_skills', as: :request_skills
  get 'users/how', as: :how_to_use
  resources :users


  resources :subsections do
    resources :questions
  end

  get "/p/:template" => 'pages#show', as: 'page'

  resources :sections do
    resources :subsections
  end

  resources :discussions, except: [:new, :index] do
    resources :comments
  end

  resources :courses do
    get 'epub', as: :epub
    resources :sections
    resources :orders
    resources :comments
    resources :discussions
    resources :updates
    resources :subsections, only: [:show]
  end

  post "coinbase/callback"

  mount Split::Dashboard, :at => 'split'
  mount Afterparty::Engine, at: "afterparty", as: "afterparty_engine"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'pages#show', template: 'about'

  unless Rails.application.config.consider_all_requests_local
    get '*not_found', to: 'errors#error_404'
  end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
