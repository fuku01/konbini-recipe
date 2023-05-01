class UsersController < ApplicationController
  # ユーザー認証をスキップする(createのアクションのみ)
  skip_before_action :authenticate_user, only: [:create]

  # ユーザー登録ページを表示し、JSON形式で返す
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

  # GET /me
  # ログインしているユーザを取得し、IDのみをJSON形式で返す
  def show_current_user
    render json: { id: @current_user.id }
  end

  # POST /users
  # 新しいユーザを作成し、JSON形式で返す
  def create
    token = params[:id_token]
    # トークンの解析をする
    payload, header = JWT.decode(token, nil, false)
    user = User.new(firebase_uid: payload["user_id"])
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
    params.require(:user).permit(:firebase_uid)
  end
end
