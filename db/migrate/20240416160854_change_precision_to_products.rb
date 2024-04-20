class ChangePrecisionToProducts < ActiveRecord::Migration[7.1]
  def change
    change_column :products, :price, :decimal, precision: 12, scale: 2
    change_column :products, :costprice, :decimal, precision: 12, scale: 2
  end
end
