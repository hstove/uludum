Ludum::Application.routes.draw do

  resources :funds do
    resources :orders
    resources :comments
  end

  get "orders/postfill" => "orders#postfill", as: :postfill

  resources :orders

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
  
  resources :sessions

  get 'users/payment_prefill' => 'users#prefill', as: :prefill_user
  get 'users/payment_postfill' => 'users#postfill', as: :postfill_user

  get 'signup' => 'users#new', :as => :signup

  get 'user/edit' => 'users#edit', :as => :edit_current_user

  resources :users


  resources :subsections do
    resources :questions
  end

  get "/p/:template" => 'pages#show', as: 'page'

  resources :sections do
    resources :subsections
  end

  resources :discussions, except: :new do
    resources :comments
  end

  resources :courses do
    resources :sections
    resources :orders
    resources :comments
    resources :discussions
  end

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
