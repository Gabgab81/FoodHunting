class AddFatToMeals < ActiveRecord::Migration[6.1]
  def change
    add_column :meals, :fat, :integer
  end
end
