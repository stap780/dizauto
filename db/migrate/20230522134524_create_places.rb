class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.string :sector
      t.string :cell
      t.integer :product_id
      t.integer :warehouse_id

      t.timestamps
    end
  end
end
