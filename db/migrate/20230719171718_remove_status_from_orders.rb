class RemoveStatusFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :status
  end
end
