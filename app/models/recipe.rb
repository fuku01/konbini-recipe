class Recipe < ApplicationRecord
  belongs_to :user
  has_many :barcodetags, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # dependent: :destroy= 親要素が削除されたら、子要素も削除されるようにするオプション

  # barcodetags_attributesで、has_many関係にあるbarcodetagsの情報を受け取るようにする。
  # これでbarcodetagsのアクションも同時に使える
  accepts_nested_attributes_for :barcodetags

  validates :title, presence: true, length: { maximum: 40 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :image, presence: true
  validates :calorie, length: { maximum: 9999 }
  validates :price, length: { maximum: 9999 }
end
