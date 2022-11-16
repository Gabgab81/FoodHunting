class CreateRatingrs < ActiveRecord::Migration[6.1]
  def change
    create_table :ratingrs do |t|
      t.float :content
      t.references :user, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
