Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
    root 'tournaments#index'
    get 'tournaments' => 'tournaments#index'
    get 'tournaments/all' => 'tournaments#all' 

    get 'tournaments/undo' => 'tournaments#undo_singles'
    get 'tournaments/create' => 'tournaments#create_tournament'
    get 'tournaments/win' => 'tournaments#win_lose_singles'
    get 'tournaments/win_doubles' => 'tournaments#win_lose_doubles'
    get 'tournaments/undo_doubles' => 'tournaments#undo_doubles'
    get 'tournaments/update_score' => 'tournaments#update_score'
    get 'tournaments/player/:id' => 'tournaments#player' 
    get 'tournaments/:id' => 'tournaments#show' 
    post 'tournaments/:id' => 'tournaments#submit_tournament'

    post 'tournaments' => 'tournaments#create_tournament'
    post 'win' => 'tournaments#win_lose_singles'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
