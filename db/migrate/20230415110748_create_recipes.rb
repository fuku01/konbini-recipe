class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.integer :time
      t.integer :calorie
      t.string :image

      t.timestamps
    end
  end
end
