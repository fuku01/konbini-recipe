class CreateBarcodetags < ActiveRecord::Migration[7.0]
  def change
    create_table :barcodetags do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :barcode
      t.string :name

      t.timestamps
    end
  end
end
