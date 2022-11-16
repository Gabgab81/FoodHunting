class RemoveProteinToMealsAgain < ActiveRecord::Migration[6.1]
  def change
    remove_column :meals, :protein, :string
  end
end
