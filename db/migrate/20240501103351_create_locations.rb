class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.references :product, null: false, foreign_key: true
      t.references :warehouse, null: false, foreign_key: true
      t.references :place, null: false, foreign_key: true

      t.timestamps
    end
  end
end
