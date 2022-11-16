class AddCarbohydrateToMeals < ActiveRecord::Migration[6.1]
  def change
    add_column :meals, :carbohydrate, :integer
  end
end
