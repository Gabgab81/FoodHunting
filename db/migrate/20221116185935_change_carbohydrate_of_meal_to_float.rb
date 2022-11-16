class ChangeCarbohydrateOfMealToFloat < ActiveRecord::Migration[6.1]
  def change
    change_column :meals, :carbohydrate, :float
  end
end
