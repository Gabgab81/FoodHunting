class Meal < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  
  belongs_to :restaurant
  has_many :ingredients, dependent: :destroy
  has_one_attached :photo

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 5 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
