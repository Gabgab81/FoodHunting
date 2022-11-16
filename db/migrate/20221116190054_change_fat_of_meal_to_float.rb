class ChangeFatOfMealToFloat < ActiveRecord::Migration[6.1]
  def change
    change_column :meals, :fat, :float
  end
end
