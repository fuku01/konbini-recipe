class AddPriceToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :price, :integer
  end
end
