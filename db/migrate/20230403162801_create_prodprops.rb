class CreateProdprops < ActiveRecord::Migration[7.0]
  def change
    create_table :prodprops do |t|
      t.string :title
      t.string :value
      t.integer :product_id
      t.integer :property_id
      t.integer :characteristic_id

      t.timestamps
    end
  end
end
