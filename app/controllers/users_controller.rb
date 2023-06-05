class UsersController < ApplicationController
  # ユーザー認証をスキップする(createのアクションのみ)
  skip_before_action :authenticate_user, only: [:create]

  # GET /me
  # ログインしているユーザを取得し、IDとNameのみをJSON形式で返す
  def show_current_user
    render json: { id: @current_user.id, name: @current_user.name }
  end

  # POST /users
  # 新しいユーザを作成し、JSON形式で返す
  def create
    token = params[:id_token]
    # トークンの解析をする
    payload, header = JWT.decode(token, nil, false)
    user = User.new(firebase_uid: payload["user_id"], name: params[:name]) # payloadとは、トークンのペイロード部分のこと
    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /edit_me
  # 指定されたIDのユーザ情報を更新し、JSON形式で返す
  def update
    user = User.find(@current_user.id)

    if user.update(user_params)
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  # ユーザの情報を受け取る際に、許可されたパラメータのみを受け取るようにする
  def user_params
    params.require(:user).permit(:firebase_uid, :name)
  end
end
