require "test_helper"

class BarcodetagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @barcodetag = barcodetags(:one)
  end

  test "should get index" do
    get barcodetags_url, as: :json
    assert_response :success
  end

  test "should create barcodetag" do
    assert_difference("Barcodetag.count") do
      post barcodetags_url, params: { barcodetag: { barcode: @barcodetag.barcode, name: @barcodetag.name, recipe_id: @barcodetag.recipe_id } }, as: :json
    end

    assert_response :created
  end

  test "should show barcodetag" do
    get barcodetag_url(@barcodetag), as: :json
    assert_response :success
  end

  test "should update barcodetag" do
    patch barcodetag_url(@barcodetag), params: { barcodetag: { barcode: @barcodetag.barcode, name: @barcodetag.name, recipe_id: @barcodetag.recipe_id } }, as: :json
    assert_response :success
  end

  test "should destroy barcodetag" do
    assert_difference("Barcodetag.count", -1) do
      delete barcodetag_url(@barcodetag), as: :json
    end

    assert_response :no_content
  end
end
