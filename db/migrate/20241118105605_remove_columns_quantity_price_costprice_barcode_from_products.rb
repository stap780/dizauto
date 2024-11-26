class RemoveColumnsQuantityPriceCostpriceBarcodeFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :quantity
    remove_column :products, :price
    remove_column :products, :costprice
    remove_column :products, :barcode
  end
end
