class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :meals, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true, length: { minimum: 5 }
  validates :phone, presence: true, format: { with: /\A\d{1}-\d{3}-\d{3}-\d{4}\z/ }
end
