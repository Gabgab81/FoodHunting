class AddProteinToMeals < ActiveRecord::Migration[6.1]
  def change
    add_column :meals, :protein, :string
  end
end
