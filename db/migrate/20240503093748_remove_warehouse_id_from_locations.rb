class RemoveWarehouseIdFromLocations < ActiveRecord::Migration[7.1]
  def change
    remove_column :locations, :warehouse_id
  end
end
