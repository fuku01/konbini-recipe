class Recipe < ApplicationRecord
  belongs_to :user
  has_many :barcodetags
  has_many :favorites

  validates :title, presence: true
  validates :content, presence: true
  validates :image, presence: true
end
