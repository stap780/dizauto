class CreateLossItems < ActiveRecord::Migration[7.1]
  def change
    create_table :loss_items do |t|
      t.references :loss, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price, precision: 12, scale: 2
      t.integer :vat
      t.decimal :sum, precision: 12, scale: 2

      t.timestamps
    end
  end
end
