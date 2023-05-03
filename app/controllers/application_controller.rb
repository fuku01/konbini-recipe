class ApplicationController < ActionController::API
  before_action :authenticate_user

  private

  # ユーザー認証
  def authenticate_user
    # リクエストヘッダーからJWTトークンを取得
    token = request.headers['Authorization']&.sub(/^Bearer /, '') # JWTトークンのペイロードを検証

    # tokenが存在しているかどうか確認する(空のことがあるので)
    if token.present?
      payload, header = JWT.decode(token, nil, false)
      # ユーザーIDからユーザーを取得
      user = User.find_by(firebase_uid: payload['user_id'])
      # ユーザーが存在しているかどうか確認する
      if user.present?
        # ユーザーが存在していれば@current_userに代入する
        @current_user = user
      end
    end

    # 認証失敗
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  # def authenticate_user
  #   id_token = request.headers['Authorization']&.sub(/^Bearer /, '') # JWTトークンのペイロードを検証
  #   decoded_token = verify_firebase_token(id_token)
  #   if decoded_token
  #     # トークンが正常に検証された場合、ログインしているユーザーの情報を返す
  #     @current_user = User.find_by(firebase_uid: decoded_token['user_id'])
  #   end
  #   # トークンが無効な場合、エラーを返す
  #   render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  # end

  # def verify_firebase_token(token)
  #   url = URI('https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com')
  #   response = Net::HTTP.get(url)
  #   certificates = JSON.parse(response)
  #   begin
  #     decoded_token = JWT.decode(token, nil, false, { jwks: certificates })
  #     # トークンの有効期限を確認して、有効期限が切れていない場合は、ペイロード部分を返す
  #     if decoded_token[0]['exp'] >= Time.now.to_i
  #       return decoded_token[0]
  #     else
  #       return nil
  #     end
  #     # ペイロード部分を返します。
  #   rescue JWT::DecodeError => e
  #     nil
  #   end
  # end
end
