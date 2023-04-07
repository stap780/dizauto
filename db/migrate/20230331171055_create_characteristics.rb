class CreateCharacteristics < ActiveRecord::Migration[7.0]
  def change
    create_table :characteristics do |t|
      t.string :title
      t.integer :property_id

      t.timestamps
    end
  end
end
