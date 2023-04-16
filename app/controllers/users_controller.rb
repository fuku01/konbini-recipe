class UsersController < ApplicationController
  # GET /users
  # 全てのユーザを取得し、JSON形式で返す
  def index
    users = User.all
    render json: users
  end

  # GET /users/1
  # 指定されたIDのユーザを取得し、JSON形式で返す
  def show
    user = User.find(params[:id])
    render json: user
  end

  # POST /users
  # 新しいユーザを作成し、JSON形式で返す
  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # 指定されたIDのユーザ情報を更新し、JSON形式で返す
  def update
    user = User.find(params[:id])

    if user.update(user_params)
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # 指定されたIDのユーザを削除する
  def destroy
    user = User.find(params[:id])
    user.destroy
  end

  private

  # ユーザの情報を受け取る際に、許可されたパラメータのみを受け取るようにする
  def user_params
    params.require(:user).permit(:name, :firebase_uid, :image)
  end
end
