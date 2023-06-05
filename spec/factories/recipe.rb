FactoryBot.define do
  factory :recipe do
    title { "Test Recipe" }
    content { "Test Recipe Content" }
    time { 30 }
    price { 500 }
    calorie { 250 }
    image { "test_image_url" }
    user # このレシピを作成するユーザー
  end
end
