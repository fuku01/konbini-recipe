class FavoritesController < ApplicationController
  # GET /favorites
  # 全てのお気に入りを取得し、JSON形式で返す
  def index
    favorites = Favorite.all
    render json: favorites
  end

  # # GET /favorites/1
  # # 指定されたIDのお気に入りを取得し、JSON形式で返す
  # def show
  #   favorite = Favorite.find(params[:id])
  #   render json: favorite
  # end

  # GET /isRecipe_favorite/recipe_id
  # 指定されたレシピが現在のユーザーによってお気に入りに登録されているかどうかを確認し、true/falseを返す
  def show_isRecipe_favorite
    favorite = Favorite.find_by(user_id: @current_user.id, recipe_id: params[:recipe_id])
    if favorite
      render json: { favorited: true, favorite_id: favorite.id }
    else
      render json: { favorited: false }
    end
  end

  # GET /my_favorites
  # ログイン中のユーザーのお気に入りを作成日の降順で取得し、JSON形式で返す
  def show_my_favorites
    favorite = Favorite.where(user_id: @current_user.id).order(created_at: :desc)
    render json: favorite
  end

  # POST /favorites
  # 指定されたレシピの新しいお気に入りを作成し、JSON形式で返す
  def create
    favorite = Favorite.new(user_id: @current_user.id, recipe_id: params[:recipe_id])

    if favorite.save
      render json: favorite, status: :created
    else
      render json: favorite.errors, status: :unprocessable_entity
    end
  end

  # DELETE /favorites/1
  # 指定されたIDのお気に入りを削除する
  def destroy
    favorite = Favorite.find(params[:id])
    if favorite.user_id == @current_user.id
      favorite.destroy
    else
      render json: { error: 'このお気に入りの削除権限がありません' }, status: :forbidden
    end
  end

  private

  # お気に入りの情報を受け取る際に、許可されたパラメータのみを受け取るようにする
  def favorite_params
    params.require(:favorite).permit(:user_id, :recipe_id)
  end
end
