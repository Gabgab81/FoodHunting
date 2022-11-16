class ChangeProteinOfMealToFloat < ActiveRecord::Migration[6.1]
  def change
    change_column :meals, :protein, :float
  end
end
