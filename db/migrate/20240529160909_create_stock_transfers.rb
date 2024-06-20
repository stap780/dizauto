class CreateStockTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :stock_transfers do |t|
      t.references :stock_transfer_status, null: false, foreign_key: true
      t.integer :origin_warehouse_id, null: false
      t.integer :destination_warehouse_id, null: false

      t.timestamps
    end
  end
end
