class ChangeContentTypeOfRatingrToInteger < ActiveRecord::Migration[6.1]
  def change
    change_column :ratingrs, :content, :integer
  end
end
