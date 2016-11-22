Rottenpotatoes::Application.routes.draw do
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
  resources :movies
  root :to => redirect('/movies')
	match '/movies/:id/similar', to: 'movies#similar', as: 'similar_movie', via: :get
	match "/movies/directed_by/:director" => "movies#directed_by", :as => :movie_direct_by

	
end

