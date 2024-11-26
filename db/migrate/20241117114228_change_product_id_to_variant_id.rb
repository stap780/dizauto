class ChangeProductIdToVariantId < ActiveRecord::Migration[7.1]
  def change
    rename_column :enter_items, :product_id, :variant_id
    rename_column :incase_items, :product_id, :variant_id
    rename_column :invoice_items, :product_id, :variant_id
    rename_column :loss_items, :product_id, :variant_id
    rename_column :locations, :product_id, :variant_id
    rename_column :order_items, :product_id, :variant_id
    rename_column :return_items, :product_id, :variant_id
    rename_column :stock_transfer_items, :product_id, :variant_id
    rename_column :stocks, :product_id, :variant_id
    rename_column :supply_items, :product_id, :variant_id

    add_index :incase_items, :variant_id
    add_index :order_items, :variant_id
    add_index :supply_items, :variant_id
  end
end
