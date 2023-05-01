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
  get '/user_recipes', to: 'recipes#show_user_recipes'
  post '/recipes', to: 'recipes#create'
  get '/recipes/:id', to: 'recipes#show'
  put '/recipes/:id', to: 'recipes#update'
  patch '/recipes/:id', to: 'recipes#update'
  delete '/recipes/:id', to: 'recipes#destroy'

  # Barcodetags
  get '/barcodetags', to: 'barcodetags#index'
  post '/barcodetags', to: 'barcodetags#create'
  get '/barcodetags/:id', to: 'barcodetags#show'
  put '/barcodetags/:id', to: 'barcodetags#update'
  patch '/barcodetags/:id', to: 'barcodetags#update'
  delete '/barcodetags/:id', to: 'barcodetags#destroy'

  # Favorites
  get '/favorites', to: 'favorites#index'
  post '/favorites', to: 'favorites#create'
  get '/favorites/:id', to: 'favorites#show'
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
