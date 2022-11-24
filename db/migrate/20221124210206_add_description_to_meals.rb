class AddDescriptionToMeals < ActiveRecord::Migration[6.1]
  def change
    add_column :meals, :description, :text
  end
end
