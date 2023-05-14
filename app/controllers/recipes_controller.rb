class RecipesController < ApplicationController
  # ユーザー認証をスキップする
  skip_before_action :authenticate_user, only: [:index, :show, :show_new_recipes]

  # GET /recipes
  # 全てのレシピを作成日の降順で取得し、JSON形式で返す
  def index
    recipes = Recipe.all.order(created_at: :desc)
    render json: recipes
  end

  # GET /new_recipes
  def show_new_recipes
    recipes = Recipe.all.order(created_at: :desc).limit(20)
    render json: recipes
  end

  # GET /recipes/1
  # 指定されたIDのレシピを取得し、JSON形式で返す
  def show
    recipe = Recipe.find(params[:id])
    render json: recipe.to_json(include: :tags) # タグ情報も含めてJSON形式で返す
  end

  # GET /my_recipes
  # ログイン中のユーザーの投稿したレシピ情報を取得し、お気に入り登録されている数もカウントした結果を代入する
  def show_my_recipes
    recipes = Recipe.where(user_id: @current_user.id)
                    .select('recipes.*, COUNT(favorites.id) as favorites_count') # favoritesテーブルのidをカウントする
                    .left_joins(:favorites) # レシピとfavoritesテーブルを結合する
                    .group('recipes.id') # レシピごとにグループ化する
                    .order(created_at: :desc) # 作成日の降順で並び替える
    render json: recipes.as_json(include: [:tags], methods: :favorites_count)
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
