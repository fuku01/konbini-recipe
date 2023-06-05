FactoryBot.define do
  factory :favorite do
    user # このお気に入りを作成するユーザー
    recipe # このレシピをお気に入りに追加する
  end
end
