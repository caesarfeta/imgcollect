Imgcollect::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  
  # Home
  match '/' => 'home#home'
  
  # Search
  match 'search/config' => 'search#config'

  # Image
  match 'image/upload' => 'image#upload'
  match 'image/show/*dir' => 'image#show', :as => :custom_image
  match 'image/preview/*id' => 'image#preview'
  match 'image/add' => 'image#add'
  match 'image/full/*id' => 'image#full'
  match 'image/update' => 'image#update'
  
  # Imgspect
  match 'imgspect/*urn/*size' => 'imgspect#load'
  
  # Imgbit
  match 'imgbit/*urn' => 'imgbit#show'
  
  # Subregion
  match 'subregion/create' => 'subregion#create'
  match 'subregion/all/*urn' => 'subregion#all'
  match 'subregion/img/*id' => 'subregion#img'
  match 'subregion/full/*id' => 'subregion#full'

  # Image by urn
  match 'urn/*urn/*size' => 'image#byUrn'

  # Images
  match 'images/all' => 'images#all'

  # Collection
  match 'collection/create' => 'collection#create'
  match 'collection/add/image' => 'collection#add_image'
  match 'collection/add/collection' => 'collection#add_subcollection'
  match 'collection/add/keyword' => 'collection#add_keyword'
  match 'collection/*id/image/sequence' => 'collection#image_sequence'
  match 'collection/*id/images' => 'collection#images'
  match 'collection/instance/*id' => 'collection#instance'
  match 'collection/full/*id' => 'collection#full'
  match 'collection/dock/*id' => 'collection#dock'
  match 'collection/citeify' => 'collection#citeify'
  match 'collection/report/*urn' => 'collection#report'
  
  # map.connect 'collection/show/:name',
  #   :controller => 'collection',
  #   :action => 'show',
  #   :name => /[0-9a-fA-F]/
    
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
