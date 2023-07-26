class RenameColumnsPaymentAndDeliveryToOrders < ActiveRecord::Migration[7.0]
  def change
    rename_column :orders, :payment_id, :payment_type_id
    rename_column :orders, :delivery_id, :delivery_type_id
  end
end
