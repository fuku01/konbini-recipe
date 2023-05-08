class TagsController < ApplicationController
  # GET /tags
  # 全てのタグを取得し、JSON形式で返す
  def index
    tags = Tag.all
    render json: tags
  end

  # GET /tags/1
  # 指定されたIDのタグを取得し、JSON形式で返す
  def show
    tag = Tag.find(params[:id])
    render json: tag
  end

  # POST /tags
  # 新しいタグを作成し、JSON形式で返す
  def create
    tag = Tag.new(tag_params)

    if tag.save
      render json: tag, status: :created, location: tag
    else
      render json: tag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tags/1
  # 指定されたIDのタグ情報を更新し、JSON形式で返す
  def update
    tag = Tag.find(params[:id])

    if tag.update(tag_params)
      render json: tag
    else
      render json: tag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tags/1
  # 指定されたIDのタグを削除する
  def destroy
    tag = Tag.find(params[:id])
    tag.destroy
  end

  private

  # タグの情報を受け取る際に、許可されたパラメータのみを受け取るようにする
  def tag_params
    params.require(:tag).permit(:recipe_id, :name)
  end
end
