class AddProteinToMealsAgain < ActiveRecord::Migration[6.1]
  def change
    add_column :meals, :protein, :integer
  end
end
