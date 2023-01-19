class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :restaurants, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :ratingrs, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :photo
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :nickname, presence: true, length: { minimum: 3 }
  validate :password_regex

  def password_regex
    return if password.blank? || password =~ /\A(?=.*\d)(?=.*[A-Z])(?=.*\W)[^ ]{8,}\z/

    errors.add :password, 'Password should have more than 7 characters including 1 uppercase letter, 1 number, 1 special character'
  end
end
