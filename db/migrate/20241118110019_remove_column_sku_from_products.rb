class RemoveColumnSkuFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :sku
  end
end
