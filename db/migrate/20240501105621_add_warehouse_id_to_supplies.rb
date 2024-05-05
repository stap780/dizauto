class AddWarehouseIdToSupplies < ActiveRecord::Migration[7.1]
  def change
    add_column :supplies, :warehouse_id, :integer
  end
end
