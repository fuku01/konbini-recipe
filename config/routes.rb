Rails.application.routes.draw do
  # Users
  get '/me', to: 'users#show_current_user' # ログインしているユーザを取得し、IDとNameのみをJSON形式で返す
  post '/users', to: 'users#create' # 新しいユーザを作成し、JSON形式で返す
  get '/users/:id', to: 'users#show' # 指定されたIDのユーザを取得し、JSON形式で返す
  put '/edit_me', to: 'users#update' # ログイン中のユーザの情報を更新し、JSON形式で返す

  # Recipes
  get '/new_recipes', to: 'recipes#show_new_recipes' # 新着レシピを作成日の降順で取得し、JSON形式で返す
  get '/rank_recipes', to: 'recipes#show_rank_recipes' # 人気レシピを作成日の降順で取得し、JSON形式で返す
  get '/search_recipes', to: 'recipes#show_search_recipes' # 指定されたキーワードを含むレシピを作成日の降順で取得し、JSON形式で返す
  get '/search_recipes_by_favorite', to: 'recipes#show_search_recipes_by_favorite' # 指定されたキーワードを含むレシピをお気に入り数の降順で取得
  get '/my_recipes', to: 'recipes#show_my_recipes' # ログイン中のユーザーのレシピを作成日の降順で取得し、JSON形式で返す
  get '/favorite_recipes', to: 'recipes#show_favorite_recipes' # ログイン中のユーザーのお気に入りレシピを作成日の降順で取得し、JSON形式で返す
  get '/recipes/:id', to: 'recipes#show' # 指定されたIDのレシピを取得し、JSON形式で返す
  post '/recipes', to: 'recipes#create' # 指定されたレシピを作成し、JSON形式で返す
  put '/recipes/:id', to: 'recipes#update' # 指定されたIDのレシピを更新し、JSON形式で返す
  delete '/recipes/:id', to: 'recipes#destroy' # 指定されたIDのレシピを削除する

  # tags
  get '/tags', to: 'tags#index'
  post '/tags', to: 'tags#create'
  get '/tags/:id', to: 'tags#show'
  put '/tags/:id', to: 'tags#update'
  patch '/tags/:id', to: 'tags#update'
  delete '/tags/:id', to: 'tags#destroy'

  # Favorites
  get '/isRecipe_favorite/:recipe_id', to: 'favorites#show_isRecipe_favorite' # ログイン中のユーザーが指定されたレシピをお気に入り登録しているかどうかを取得
  get '/favorite_count/:recipe_id', to: 'favorites#show_favorite_count' # 指定されたレシピのお気に入り数を取得し、JSON形式で返す
  post '/favorites', to: 'favorites#create' # 指定されたレシピをお気に入り登録する
  delete '/favorites/:id', to: 'favorites#destroy' # 指定されたIDのお気に入りを削除する
end
