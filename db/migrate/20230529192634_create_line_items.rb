class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.integer :incase_id
      t.string :title
      t.integer :quantity
      t.string :katnumber
      t.decimal :price, precision: 12, scale: 2
      t.decimal :sum, precision: 12, scale: 2
      t.string :status

      t.timestamps
    end
  end
end
