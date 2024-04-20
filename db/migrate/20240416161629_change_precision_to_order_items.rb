class ChangePrecisionToOrderItems < ActiveRecord::Migration[7.1]
  def change
    change_column :order_items, :price, :decimal, precision: 12, scale: 2
    change_column :order_items, :sum, :decimal, precision: 12, scale: 2
  end
end
