class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :stockable, polymorphic: true, null: false
      t.string :move
      t.integer :value

      t.timestamps
    end
  end
end
