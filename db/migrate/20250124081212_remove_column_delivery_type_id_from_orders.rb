class RemoveColumnDeliveryTypeIdFromOrders < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :delivery_type_id
  end
end
