AlgolintCom::Application.routes.draw do

  resources :likes


  resources :contents
  devise_for :users, :skip => [:sessions]
  as :user do
    get 'join' => 'devise/registrations#new', :as => :signin_user
    get 'login' => 'devise/sessions#new', :as => :login_user
    post 'login' => 'devise/sessions#create', :as => :user_session
    get 'logout' => 'devise/sessions#destroy', :as => :logout_user
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
  root :to => 'home#homepage'
  match "/compile-code" => "home#compile_code", :as => :compile_code
  match "/set-user-config-editor" => "home#set_default_user_editor_setting", :as => :set_default_user_editor_setting

  match "/like-code/:code_id" => "home#like_code", :as => :like_code
  match "/:uid" => "home#profile", :as => :profile
  match "/:uid/:file_name-:file_id" => "home#content_public", :as => :content_public
  
  # Admin Urls
  match "/admin" => "home#admin", :as => :admin
  match "/list-codes-for-template" => "home#list_codes", :as => :list_codes
  match "/make-tempate/:id" => "home#make_template", :as => :make_template
  match "/set-tempate-cat/:id/(:cat)" => "home#set_template_cat", :as => :set_template_cat
  
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
