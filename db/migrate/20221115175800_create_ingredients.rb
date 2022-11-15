class CreateIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :ingredients do |t|
      t.text :info
      t.bigint :code
      t.string :name
      t.string :image
      t.references :meal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
