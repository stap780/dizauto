class AddPositionToWarehouses < ActiveRecord::Migration[7.1]
  def change
    add_column :warehouses, :position, :integer, null: false, default: 1
  end
end
