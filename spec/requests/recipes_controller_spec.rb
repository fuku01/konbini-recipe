# spec/requests/recipes_controller_spec.rb
require 'rails_helper'

RSpec.describe RecipesController, type: :request do
  let(:user) { create(:user) } # テスト用のユーザーを作成
  let!(:recipe) { create(:recipe, user: user) }

  # JWTトークンを仮で生成するメソッド
  def generate_token(user)
    payload = { user_id: user.firebase_uid }
    JWT.encode(payload, nil, 'none') # JWTトークンを生成
  end

  # レシピを取得するAPIのテスト
  describe 'GET #show' do
    it 'returns a success response' do
      get "/recipes/#{recipe.id}"
      expect(response.status).to eq(200) # ステータスコードが200であること
      expect(response.body).to include(recipe.title) # レスポンスにレシピのタイトルが含まれていること
      expect(response.body).to include(recipe.image) # レスポンスにレシピの画像が含まれていること
      expect(response.body).to include(recipe.content) # レスポンスにレシピの作り方が含まれていること
    end
  end

  # レシピを作成するAPIのテスト
  describe 'POST #create' do
    it 'returns a success response' do
      token = generate_token(user) # JWTトークンを生成
      post '/recipes', params: { recipe: { title: 'New Recipe', content: 'New content', image: 'New.jpg' } }, headers: { 'Authorization': "Bearer #{token}" } # ヘッダーにトークンを設定
      expect(response.status).to eq(201) # ステータスコードが201であること
    end
  end

  # レシピを編集するAPIのテスト
  describe 'PUT #update' do
    it 'returns a success response' do
      token = generate_token(user) # JWTトークンを生成
      put "/recipes/#{recipe.id}", params: { recipe: { title: 'Edit Recipe', content: 'Edit content', image: 'edit.jpg' } }, headers: { 'Authorization': "Bearer #{token}" } # ヘッダーにトークンを設定
      expect(response.status).to eq(200) # ステータスコードが201であること
    end
  end

  # レシピを削除するAPIのテスト
  describe 'DELETE #destroy' do
    it 'returns a success response' do
      token = generate_token(user) # JWTトークンを生成
      delete "/recipes/#{recipe.id}", headers: { 'Authorization': "Bearer #{token}" } # ヘッダーにトークンを設定
      expect(response.status).to eq(204) # ステータスコードが204であること
    end
  end

  # 新着レシピを取得するAPIのテスト
  describe 'GET #show_new_recipes' do
    it 'returns a success response' do
      get '/new_recipes'
      expect(response.status).to eq(200) # ステータスコードが200であること
      json = JSON.parse(response.body) # レスポンスをJSONに変換
      expect(json.length).to be <= 20 # レシピが最大20件であること
    end
  end

  # 人気レシピを取得するAPIのテスト
  describe 'GET #show_rank_recipes' do
    it 'returns a success response' do
      get '/rank_recipes'
      expect(response.status).to eq(200) # ステータスコードが200であること
      json = JSON.parse(response.body) # レスポンスをJSONに変換
      expect(json.length).to be <= 20 # レシピが最大20件であること
    end
  end

  # レシピを検索するAPIのテスト
  describe 'GET #show_search_recipes' do
    it 'returns a success response' do
      get '/search_recipes?page=1&searchWords[]=test'
      expect(response.status).to eq(200) # ステータスコードが200であること
      json = JSON.parse(response.body) # レスポンスをJSONに変換
      expect(json.length).to be <= 20 # レシピが最大20件であること
    end
  end

  # レシピを検索（人気順で取得）するAPIのテスト
  describe 'GET #search_recipes_by_favorite' do
    it 'returns a success response' do
      get '/search_recipes_by_favorite?page=1&searchWords[]=test'
      expect(response.status).to eq(200) # ステータスコードが200であること
      json = JSON.parse(response.body) # レスポンスをJSONに変換
      expect(json.length).to be <= 20 # レシピが最大20件であること
    end
  end

  # マイレシピを取得するAPIのテスト
  describe 'GET #show_my_recipes' do
    it 'returns a success response' do
      token = generate_token(user) # JWTトークンを生成
      get '/my_recipes', headers: { 'Authorization': "Bearer #{token}" } # ヘッダーにトークンを設定
      expect(response.status).to eq(200) # ステータスコードが200であること
      json = JSON.parse(response.body) # レスポンスをJSONに変換
      expect(json.length).to be <= 20 # レシピが最大20件であること
    end
  end
  # お気に入りレシピを取得するAPIのテスト
  describe 'GET #show_favorite_recipes' do
    it 'returns a success response' do
      token = generate_token(user) # JWTトークンを生成
      get '/favorite_recipes', headers: { 'Authorization': "Bearer #{token}" } # ヘッダーにトークンを設定
      expect(response.status).to eq(200) # ステータスコードが200であること
      json = JSON.parse(response.body) # レスポンスをJSONに変換
      expect(json.length).to be <= 20 # レシピが最大20件であること
    end
  end
end
