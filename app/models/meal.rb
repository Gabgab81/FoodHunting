class Meal < ApplicationRecord
  belongs_to :restaurant
  has_many :ingredients, dependent: :destroy
  has_one_attached :photo

  validates :name, presence: true
  validates :price, presence: true
end
