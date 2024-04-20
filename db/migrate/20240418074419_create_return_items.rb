class CreateReturnItems < ActiveRecord::Migration[7.1]
  def change
    create_table :return_items do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :price, precision: 12, scale: 2
      t.integer :discount
      t.decimal :sum, precision: 12, scale: 2
      t.integer :quantity
      t.integer :vat
      t.references :return, null: false, foreign_key: true

      t.timestamps
    end
  end
end
