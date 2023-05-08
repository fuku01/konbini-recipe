class Recipe < ApplicationRecord
  belongs_to :user
  has_many :tags, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # dependent: :destroy= 親要素が削除されたら、子要素も削除されるようにするオプション

  # 親要素と子要素を同時に作成・更新するための記述(allow_destroyはレシピ編集の際にタグの削除もするためのオプション)
  accepts_nested_attributes_for :tags, allow_destroy: true

  validates :title, presence: true, length: { maximum: 40 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :image, presence: true
  validates :calorie, length: { maximum: 9999 }
  validates :price, length: { maximum: 9999 }
end
