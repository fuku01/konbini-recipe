Rails.application.routes.draw do
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
