class CreateVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :sku
      t.string :barcode
      t.integer :quantity
      t.decimal :cost_price
      t.decimal :price

      t.timestamps
    end
  end
end
