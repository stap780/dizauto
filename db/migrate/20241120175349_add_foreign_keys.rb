class AddForeignKeys < ActiveRecord::Migration[7.1]
  def change
    remove_column :enter_items, :variant_id
    remove_column :invoice_items, :variant_id
    remove_column :locations, :variant_id
    remove_column :loss_items, :variant_id
    remove_column :return_items, :variant_id
    remove_column :stock_transfer_items, :variant_id
    remove_column :stocks, :variant_id

    add_reference :enter_items, :variant
    add_reference :invoice_items, :variant
    add_reference :locations, :variant
    add_reference :loss_items, :variant
    add_reference :return_items, :variant
    add_reference :stock_transfer_items, :variant
    add_reference :stocks, :variant
  end
end
