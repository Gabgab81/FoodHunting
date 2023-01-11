class Ingredient < ApplicationRecord
  belongs_to :meal
  serialize :info

  validates :code, presence: true, length: { is: 13 }
  validates :weight, presence: true
  validates :name, presence: true, length: { minimum: 3 }
end
