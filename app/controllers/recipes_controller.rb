class RecipesController < ApplicationController
  # ユーザー認証をスキップする
  skip_before_action :authenticate_user, only: [:index]

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
    render json: recipe
  end

  # GET /user_recipes
  # ログイン中のユーザーのマイレシピを取得し、JSON形式で返す
  def show_user_recipes
    recipes = Recipe.where(user_id: @current_user.id)
    render json: recipes
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
  def recipe_params
    params.require(:recipe).permit(:title, :content, :time, :price, :calorie, :image)
  end
end
