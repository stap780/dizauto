class CreateSupplyItems < ActiveRecord::Migration[7.0]
  def change
    create_table :supply_items do |t|
      t.integer :supply_id
      t.integer :product_id
      t.integer :warehouse_id
      t.integer :quantity, default: 0
      t.decimal :price, precision: 12, scale: 2
      t.decimal :sum, precision: 12, scale: 2
      t.decimal :total, precision: 12, scale: 2

      t.timestamps
    end
  end
end
