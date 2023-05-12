Rails.application.routes.draw do
  # Users
  get '/users', to: 'users#index'
  post '/users', to: 'users#create'
  get '/users/:id', to: 'users#show'
  get '/me', to: 'users#show_current_user'
  put '/users/:id', to: 'users#update'
  patch '/users/:id', to: 'users#update'
  delete '/users/:id', to: 'users#destroy'

  # Recipes
  get '/recipes', to: 'recipes#index'
  get '/new_recipes', to: 'recipes#show_new_recipes'
  get '/my_recipes', to: 'recipes#show_my_recipes'
  post '/recipes', to: 'recipes#create'
  get '/recipes/:id', to: 'recipes#show'
  put '/recipes/:id', to: 'recipes#update'
  patch '/recipes/:id', to: 'recipes#update'
  delete '/recipes/:id', to: 'recipes#destroy'

  # tags
  get '/tags', to: 'tags#index'
  post '/tags', to: 'tags#create'
  get '/tags/:id', to: 'tags#show'
  put '/tags/:id', to: 'tags#update'
  patch '/tags/:id', to: 'tags#update'
  delete '/tags/:id', to: 'tags#destroy'

  # Favorites
  get '/favorites', to: 'favorites#index'
  post '/favorites', to: 'favorites#create'
  get '/favorites/:id', to: 'favorites#show'
  get '/isRecipe_favorite/:recipe_id', to: 'favorites#show_isRecipe_favorite'
  get '/favorite_count/:recipe_id', to: 'favorites#show_favorite_count'
  get '/my_favorites', to: 'favorites#show_my_favorites'
  put '/favorites/:id', to: 'favorites#update'
  patch '/favorites/:id', to: 'favorites#update'
  delete '/favorites/:id', to: 'favorites#destroy'

  # index
  get '/todos', to: 'todos#index'
  # show
  get '/todos/:id', to: 'todos#show'
  # create
  post '/todos', to: 'todos#create'
  # update
  # put '/todos/:id', to: 'todos#update'
  patch '/todos/:id', to: 'todos#update'
  # delete
  delete '/todos/:id', to: 'todos#destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
end
