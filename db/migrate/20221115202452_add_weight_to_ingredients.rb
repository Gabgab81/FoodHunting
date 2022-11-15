class AddWeightToIngredients < ActiveRecord::Migration[6.1]
  def change
    add_column :ingredients, :weight, :integer
  end
end
