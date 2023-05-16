class Recipe < ApplicationRecord
  belongs_to :user
  has_many :tags, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # dependent: :destroy= 親要素が削除されたら、子要素も削除されるようにするオプション

  # 親要素と子要素を同時に作成・更新するための記述(allow_destroyはレシピ編集の際にタグの削除もするためのオプション)
  accepts_nested_attributes_for :tags, allow_destroy: true

  # presence: true= 空の値を許可しない
  validates :title, presence: true, length: { maximum: 20 } # length: { maximum: 20 }= 20文字以内であることを確認する
  validates :content, presence: true, length: { maximum: 500 } # length: { maximum: 500 }= 500文字以内であることを確認する
  validates :image, presence: true # presence: true= 空の値を許可しない
  validates :calorie, length: { maximum: 9999 } # length: { maximum: 9999 }= 9999文字以内であることを確認する
  validates :price, length: { maximum: 9999 } # length: { maximum: 9999 }= 9999文字以内であることを確認する

  # タグの数が 5 以下であることを確認するカスタムバリデーションを追加
  validate :tags_count_within_limit
  validate :tags_length_within_limit

  private

  # タグの文字数が 15 以下であることを確認するカスタムバリデーション
  def tags_length_within_limit
    tags.each do |tag| # tags.each= tagsの中身を一つずつ取り出す
      if tag.name.length > 15
        errors.add(:tags, "は15文字までしか追加できません")
      end
    end
  end

  # タグの数が 5 以下であることを確認するカスタムバリデーション
  def tags_count_within_limit
    if tags.size > 10 # 削除５個＋追加５個＝最大１０個のリクエスト(一時的に登録したタグ（ID無いもの）はカウントされないため最大１０個)
      errors.add(:tags, "は5個までしか追加できません")
    end
  end
end
