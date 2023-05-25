class RecipesController < ApplicationController
  # pagyを使用するために必要
  include Pagy::Backend
  # include Pagy::Frontend

  # ユーザー認証をスキップする
  skip_before_action :authenticate_user,
                     only: [:index, :show, :show_new_recipes, :show_rank_recipes, :show_search_recipes,
                            :show_search_recipes_by_favorite]

  # GET /recipes
  # 全てのレシピを作成日の降順で取得し、JSON形式で返す
  def index
    recipes = Recipe.all.order(created_at: :desc)
    render json: recipes
  end

  # GET /new_recipes
  # 新着レシピ２０件を取得し、JSON形式で返す
  def show_new_recipes
    recipes = Recipe.all.order(created_at: :desc).limit(20)
    render json: recipes
  end

  # GET /rank_recipes
  # いいねの数が多い順にレシピを２０件取得し、JSON形式で返す
  def show_rank_recipes
    recipes = Recipe.joins(:favorites)
                    .select('recipes.*, COUNT(favorites.id) as favorites_count')
                    .group('recipes.id')
                    .order('favorites_count DESC').limit(20)
    render json: recipes.as_json(methods: :favorites_count)
  end

  # GET /search_recipes
  # リクエストで取得したsearchWordが、レシピの情報に含むレシピを取得し、JSON形式で返す
  def show_search_recipes
    search_words = params[:searchWords] # フロントから送られてきた検索ワードの配列
    recipes = Recipe.left_joins(:tags).left_joins(:favorites) # left_joins= レシピにいいねがない場合でも取得する
    search_words.each do |word| # 検索ワードの配列を一つずつ取り出す
      recipes = recipes.where('title LIKE ?', "%#{word}%") # レシピのタイトルに検索ワードが含まれるものを取得
                       .or(recipes.where('content LIKE ?', "%#{word}%")) # レシピの内容に検索ワードが含まれるものを取得
                       .or(recipes.where('tags.name LIKE ?', "%#{word}%")) # タグの名前に検索ワードが含まれるものを取得
    end
    favorites_subquery = '(SELECT COUNT(*) FROM favorites WHERE favorites.recipe_id = recipes.id)' # サブクエリを使用していいねの数を取得
    recipes = recipes.select("recipes.*, #{favorites_subquery} as favorites_count") # favoritesテーブルのidをカウントする（いいねの数を取得）
                     .group('recipes.id') # レシピごとにグループ化する
                     .order(created_at: :desc) # 作成日の降順で並び替える
                     .distinct # 重複するレシピを削除して一意なレシピのみを保持する
    pagy, records = pagy(recipes, items: 10) # ページネーションを行う
    render json: { recipes: records.as_json(methods: :favorites_count), pagy: pagy } # レシピ情報にfavorites_countを追加してJSON形式で
  end

  # GET /search_recipes_by_favorite
  # リクエストで取得したsearchWordが、レシピの情報に含むレシピを取得し、JSON形式で返す【お気に入り順】
  def show_search_recipes_by_favorite
    search_words = params[:searchWords] # フロントから送られてきた検索ワードの配列
    recipes = Recipe.left_joins(:tags).left_joins(:favorites) # left_joins= レシピにいいねがない場合でも取得する
    search_words.each do |word| # すべての検索ワードについてループを行う
      # それぞれの検索ワードでレシピテーブルのtitleとcontent、およびtagsテーブルのnameを検索
      recipes = recipes.where('title LIKE ?', "%#{word}%") # レシピのタイトルに検索ワードが含まれるものを取得
                       .or(recipes.where('content LIKE ?', "%#{word}%")) # レシピの内容に検索ワードが含まれるものを取得
                       .or(recipes.where('tags.name LIKE ?', "%#{word}%")) # タグの名前に検索ワードが含まれるものを取得
    end
    favorites_subquery = '(SELECT COUNT(*) FROM favorites WHERE favorites.recipe_id = recipes.id)' # サブクエリを使用していいねの数を取得
    recipes = recipes.select("recipes.*, #{favorites_subquery} as favorites_count") # favoritesテーブルのidをカウントする（いいねの数を取得）
                     .group('recipes.id') # レシピごとにグループ化する
                     .order(Arel.sql("(#{favorites_subquery}) DESC")) # いいねの数の降順で並び替える
                     .distinct # 重複するレシピを削除して一意なレシピのみを保持する
    pagy, records = pagy(recipes, items: 10) # ページネーションを行う
    render json: { recipes: records.as_json(methods: :favorites_count), pagy: pagy } # レシピ情報にfavorites_countを追加してJSON形式で
  end

  # GET /recipes/1
  # 指定されたIDのレシピを取得し、JSON形式で返す
  def show
    recipe = Recipe.find(params[:id])
    render json: recipe.to_json(include: [:tags, :user]) # タグ情報とユーザー情報を含めてJSON形式で返す
  end

  # GET /my_recipes
  # ログイン中のユーザーの投稿したレシピ情報を取得し、お気に入り登録されている数もカウントした結果を代入する
  def show_my_recipes
    recipes = Recipe.where(user_id: @current_user.id)
                    .select('recipes.*, COUNT(favorites.id) as favorites_count') # favoritesテーブルのidをカウントする（いいねの数を取得）
                    .left_joins(:favorites) # レシピとfavoritesテーブルを結合する（いいねしてないものも含む）
                    .group('recipes.id') # レシピごとにグループ化する
                    .order(created_at: :desc) # 作成日の降順で並び替える
    pagy, records = pagy(recipes, items: 10) # ページネーションを行う
    render json: { recipes: records.as_json(methods: :favorites_count), pagy: pagy } # レシピ情報にfavorites_countを追加してJSON形式で
  end

  # GET /favorite_recipes
  # ログイン中のユーザーのいいねしたレシピ情報を取得し、お気に入り登録されている数もカウントした結果を代入する
  def show_favorite_recipes
    recipes = Recipe.joins(:favorites) # レシピとfavoritesテーブルを結合する（いいねしてるものだけ）
                    .where(favorites: { user_id: @current_user.id }) # favoritesテーブルのuser_idがログイン中のユーザーのIDと一致するレシピを取得する
                    .select('recipes.*, COUNT(favorites.id) as favorites_count') # favoritesテーブルのidをカウントする（いいねの数を取得）
                    .group('recipes.id') # レシピごとにグループ化する
                    .order('favorites.created_at DESC') # favoritesテーブルの作成日の降順で並び替える
    pagy, records = pagy(recipes, items: 10) # ページネーションを行う
    render json: { recipes: records.as_json(methods: :favorites_count), pagy: pagy } # レシピ情報にfavorites_countを追加してJSON形式で
  end

  # POST /recipes
  # 新しいレシピを作成し、JSON形式で返す
  def create
    recipe = Recipe.new(recipe_params)
    recipe.user_id = @current_user.id

    if recipe.save
      render json: recipe, status: :created
    else
      puts recipe.errors.inspect # Add this line to output error messages
      render json: recipe.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /recipes/1
  # 指定されたIDのレシピ情報を更新し、JSON形式で返す
  def update
    recipe = Recipe.find(params[:id])
    if recipe.user_id == @current_user.id
      if recipe.update(recipe_params)
        render json: recipe
      else
        render json: recipe.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'このレシピの編集権限がありません' }, status: :forbidden
    end
  end

  # DELETE /recipes/1
  # 指定されたIDのレシピを削除する
  def destroy
    recipe = Recipe.find(params[:id])
    if recipe.user_id == @current_user.id
      recipe.destroy
    else
      render json: { error: 'このレシピの削除権限がありません' }, status: :forbidden
    end
  end

  private

  # レシピの情報を受け取る際に、許可されたパラメータのみを受け取るようにする
  # tags_attributes（親要素と子要素を同時に作成・更新するための記述）で、
  # has_many関係にあるtagsの情報を受け取るようにする。
  def recipe_params
    params.require(:recipe).permit(:title, :content, :time, :price, :calorie, :image,
                                   tags_attributes: [:id, :name, :_destroy])
  end
end
