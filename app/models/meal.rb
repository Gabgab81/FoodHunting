class Meal < ApplicationRecord
  belongs_to :restaurant
  has_many :ingredients, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true
end
