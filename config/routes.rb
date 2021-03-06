AlgolintCom::Application.routes.draw do
  resources :user_compiles
  resources :image_configs
  resources :packages
  resources :containers
  resources :container_stacks
  resources :networks
  resources :compilers
  resources :languages

  resources :folders
  resources :likes
  resources :contents
  devise_for :users, :skip => [:sessions]
  as :user do
    get 'join' => 'devise/registrations#new', :as => :signin_user
    get 'login' => 'sessions#new', :as => :login_user
    post 'login' => 'sessions#create', :as => :user_session
    get 'logout' => 'sessions#destroy', :as => :logout_user
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

  # Admin Urls
  match "/admin" => "home#admin", :as => :admin
  match "/list-codes-for-template" => "home#list_codes", :as => :list_codes
  match "/list-users-for-admin" => "home#list_users", :as => :list_users
  match "/make-tempate/:id" => "home#make_template", :as => :make_template
  match "/set-tempate-cat/:id/(:cat)" => "home#set_template_cat", :as => :set_template_cat

  # Dropbox Urls
  get "dropbox/auth_start"
  get "dropbox/auth_finish"
  
  # Main Urls
  match "/get-profile-url" => "home#get_profile_name", :as => :get_profile_name
  match "/how-to-use" => "home#how_to_use", :as => :how_to_use
  match "/cli" => "home#cli", :as => :cli
  match "/explore" => "home#explore", :as => :explore
  match "/check-profile-name-availabilty" => "home#check_profile_name_avail", :as => :check_profile_name_avail
  match "/save-profile-url" => "home#save_profile_url", :as => :save_profile_name
  match "/reuse-code/:file_Id" => "home#reuse_code", :as => :reuse_code
  match "/compile-code" => "home#compile_code", :as => :compile_code
  match "/set-user-config-editor" => "home#set_default_user_editor_setting", :as => :set_default_user_editor_setting
  match "/like-code/:code_id" => "home#like_code", :as => :like_code
  match "/complete-dropbox-integration" => "dropbox#complete_integration", :as => :comp_dropbox_integration  
  match "/sync-to-dropbox" => "dropbox#upload", :as => :sync_to_dropbox  
  match "/:uid" => "home#profile", :as => :profile
  match "/:uid/:file_name-:file_id" => "home#content_public", :as => :content_public
  
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
