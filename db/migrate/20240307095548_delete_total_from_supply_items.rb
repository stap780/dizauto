class DeleteTotalFromSupplyItems < ActiveRecord::Migration[7.1]
  def change
    remove_column :supply_items, :total
  end
end
