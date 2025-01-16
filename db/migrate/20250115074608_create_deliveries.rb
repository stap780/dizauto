class CreateDeliveries < ActiveRecord::Migration[7.1]
  def change
    create_table :deliveries do |t|
      t.references :order, null: false, foreign_key: true
      t.references :delivery_type, null: false, foreign_key: true
      t.decimal :price

      t.timestamps
    end
  end
end
