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

  # タグの数が 5 以下であることを確認するカスタムバリデーションを追加
  validate :tags_count_within_limit

  private

  def tags_count_within_limit
    puts tags
    if tags.size > 10 # 削除５個＋追加５個＝最大１０個のリクエスト
      errors.add(:tags, "は5個までしか追加できません")
    end
  end
end
