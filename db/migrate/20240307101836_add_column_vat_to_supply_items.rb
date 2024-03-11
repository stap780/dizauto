class AddColumnVatToSupplyItems < ActiveRecord::Migration[7.1]
  def change
    add_column :supply_items, :vat, :integer, default: 0, null: false
  end
end
