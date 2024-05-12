class CreateEnterItems < ActiveRecord::Migration[7.1]
  def change
    create_table :enter_items do |t|
      t.references :enter, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price
      t.integer :vat
      t.decimal :sum

      t.timestamps
    end
  end
end
