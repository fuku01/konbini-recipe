class Recipe < ApplicationRecord
  belongs_to :user
  has_many :barcodetags
  has_many :favorites

  validates :title, presence: true, length: { maximum: 40 }
  validates :content, presence: true, length: { maximum: 300 }
  validates :image, presence: true
end
