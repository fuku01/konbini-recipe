class BarcodetagsController < ApplicationController
  # GET /barcodetags
  # 全てのバーコードタグを取得し、JSON形式で返す
  def index
    barcodetags = Barcodetag.all
    render json: barcodetags
  end

  # GET /barcodetags/1
  # 指定されたIDのバーコードタグを取得し、JSON形式で返す
  def show
    barcodetag = Barcodetag.find(params[:id])
    render json: barcodetag
  end

  # POST /barcodetags
  # 新しいバーコードタグを作成し、JSON形式で返す
  def create
    barcodetag = Barcodetag.new(barcodetag_params)

    if barcodetag.save
      render json: barcodetag, status: :created, location: barcodetag
    else
      render json: barcodetag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /barcodetags/1
  # 指定されたIDのバーコードタグ情報を更新し、JSON形式で返す
  def update
    barcodetag = Barcodetag.find(params[:id])

    if barcodetag.update(barcodetag_params)
      render json: barcodetag
    else
      render json: barcodetag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /barcodetags/1
  # 指定されたIDのバーコードタグを削除する
  def destroy
    barcodetag = Barcodetag.find(params[:id])
    barcodetag.destroy
  end

  private

  # バーコードタグの情報を受け取る際に、許可されたパラメータのみを受け取るようにする
  def barcodetag_params
    params.require(:barcodetag).permit(:recipe_id, :barcode, :name)
  end
end
