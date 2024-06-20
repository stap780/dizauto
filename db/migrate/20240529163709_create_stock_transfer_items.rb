class CreateStockTransferItems < ActiveRecord::Migration[7.1]
  def change
    create_table :stock_transfer_items do |t|
      t.references :product, null: false, foreign_key: true
      t.references :stock_transfer, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price
      t.integer :vat
      t.decimal :sum

      t.timestamps
    end
  end
end
