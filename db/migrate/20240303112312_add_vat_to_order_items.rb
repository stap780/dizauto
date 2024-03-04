class AddVatToOrderItems < ActiveRecord::Migration[7.1]
  def change
    add_column :order_items, :vat, :integer, null: false, default: 0
  end
end
