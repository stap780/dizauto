class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :sku
      t.string :barcode
      t.string :title
      t.string :description
      t.integer :quantity
      t.decimal :costprice
      t.decimal :price
      t.string :video

      t.timestamps
    end
  end
end
