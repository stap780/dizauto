class RemoveWarehouseIdFromSupplyItems < ActiveRecord::Migration[7.1]
  def change
    remove_column :supply_items, :warehouse_id
  end
end
