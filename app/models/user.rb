class User < ApplicationRecord
  has_many :recipes
  has_many :favorites

  validates :name, presence: true, length: { maximum: 10 } # length: { maximum: 10 }= 10文字以内であることを確認する
end
