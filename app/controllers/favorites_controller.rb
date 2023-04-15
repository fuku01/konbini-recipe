class FavoritesController < ApplicationController
  # GET /favorites
  # 全てのお気に入りを取得し、JSON形式で返す
  def index
    favorites = Favorite.all
    render json: favorites
  end

  # GET /favorites/1
  # 指定されたIDのお気に入りを取得し、JSON形式で返す
  def show
    favorite = Favorite.find(params[:id])
    render json: favorite
  end

  # POST /favorites
  # 新しいお気に入りを作成し、JSON形式で返す
  def create
    favorite = Favorite.new(favorite_params)

    if favorite.save
      render json: favorite, status: :created, location: favorite
    else
      render json: favorite.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /favorites/1
  # 指定されたIDのお気に入り情報を更新し、JSON形式で返す
  def update
    favorite = Favorite.find(params[:id])

    if favorite.update(favorite_params)
      render json: favorite
    else
      render json: favorite.errors, status: :unprocessable_entity
    end
  end

  # DELETE /favorites/1
  # 指定されたIDのお気に入りを削除する
  def destroy
    favorite = Favorite.find(params[:id])
    favorite.destroy
  end

  private

  # お気に入りの情報を受け取る際に、許可されたパラメータのみを受け取るようにする
  def favorite_params
    params.require(:favorite).permit(:user_id, :recipe_id)
  end
end
