class Recipe < ApplicationRecord
  belongs_to :user
  has_many :barcodetags
  has_many :favorites

  validates :title, presence: true, length: { maximum: 40 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :image, presence: true
  validates :calorie, length: { maximum: 9999 }
  validates :price, length: { maximum: 9999 }
end
