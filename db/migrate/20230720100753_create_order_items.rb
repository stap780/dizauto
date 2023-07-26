class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.integer :product_id
      t.decimal :price
      t.integer :discount
      t.decimal :sum
      t.integer :order_id

      t.timestamps
    end
  end
end
