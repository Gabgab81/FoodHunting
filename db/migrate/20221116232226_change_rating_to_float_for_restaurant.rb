class ChangeRatingToFloatForRestaurant < ActiveRecord::Migration[6.1]
  def change
    change_column :restaurants, :rating, :float
  end
end
