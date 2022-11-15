class Ingredient < ApplicationRecord
  belongs_to :meal
  serialize :info

  validates :code, presence: true, length: { is: 13 }
end
