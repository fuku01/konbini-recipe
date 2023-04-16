class RecipesController < ApplicationController
  # GET /recipes
  # 全てのレシピを取得し、JSON形式で返す
  def index
    recipes = Recipe.all
    render json: recipes
  end

  # GET /recipes/1
  # 指定されたIDのレシピを取得し、JSON形式で返す
  def show
    recipe = Recipe.find(params[:id])
    render json: recipe
  end

  # POST /recipes
  # 新しいレシピを作成し、JSON形式で返す
  def create
    recipe = Recipe.new(recipe_params)

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

    if recipe.update(recipe_params)
      render json: recipe
    else
      render json: recipe.errors, status: :unprocessable_entity
    end
  end

  # DELETE /recipes/1
  # 指定されたIDのレシピを削除する
  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
  end

  private

  # レシピの情報を受け取る際に、許可されたパラメータのみを受け取るようにする
  def recipe_params
    params.require(:recipe).permit(:user_id, :title, :content, :time, :price, :calorie, :image)
  end
end
