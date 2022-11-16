class Ratingr < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant

  validates :content, inclusion: { in: [1, 2, 3, 4, 5],
  message: "Select a number between 1 and 5" }
end
